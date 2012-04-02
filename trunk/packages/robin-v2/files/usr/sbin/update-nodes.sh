#!/bin/sh

<<COPYRIGHT

Copyright (C) 2010 Antonio Anselmi <tony.anselmi@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of version 2 of the GNU General Public
License as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this file.  If not, see <http://www.gnu.org/licenses/>.

COPYRIGHT

# /usr/sbin/update-nodes.sh

CALLER=$1
CALLER="${CALLER:-1}"
WDIR=/etc/update

[ -s "$WDIR/nodes" ] || exit 1

if [ -e "$WDIR/network_nodes" ]; then
	network_nodes_MD5=$(md5sum $WDIR/network_nodes |awk '{print $1}')
 	nodes_MD5=$(md5sum $WDIR/nodes |awk '{print $1}')
	[ "$network_nodes_MD5" == "$nodes_MD5" ] && UPDATE_NODES=0 || UPDATE_NODES=1

else
	UPDATE_NODES=1
fi

[ 0 -eq "$UPDATE_NODES" ] && exit 0
cp -f $WDIR/nodes $WDIR/network_nodes

k_strict_mesh=$(uci get management.enable.strict_mesh)
IP_mesh=$(uci get node.general.IP_mesh)

while read r ; do
	NODE_IP=$(echo $r |awk '{print $2}')

	if [ "$IP_mesh" == "$NODE_IP" ] ; then
		NODE_NAME=$(echo $r |awk '{print $3}'|tr -d '\n\r\v' |tr [*] ['_'] |sed  s/"'"//g )

		if echo $NODE_NAME |grep -q '@@' ; then
			HOST_NAME=$(echo $THIS_NODE_NAME |awk -F @@ '{print $1}')
		
		else
			HOST_NAME=$NODE_NAME
		fi

		uci set system.@system[0].hostname=$HOST_NAME
		uci commit system

		echo "$HOST_NAME" > /proc/sys/kernel/hostname
	fi
done < $WDIR/nodes

if [ 1 -eq "$CALLER" ]; then
	ARRANGE_MESH=$(uci get management.enable.strict_mesh)
	[ "$ARRANGE_MESH" -gt 0 ] && {
		[ 9 -eq "$ARRANGE_MESH" ] && sh /lib/robin/limited-mesh.sh
		sh /lib/robin/strict-mesh.sh
	}
fi
#



