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

#/lib/robin/limited-mesh.sh (a variant of strict-mesh)
# allowing mesh only amomg nodes which join the same group(s)

GROUP_MESH="/var/run/limited.mesh"
TEMP_GROUP_MESH="/var/run/limited.mesh.temp"
NETWORK_NODES="/etc/update/network_nodes"

MY_MESH_IP=$(uci get node.general.IP_mesh)
k_strict_mode=$(uci get management.enable.strict_mesh)

rm -f $TEMP_GROUP_MESH $GROUP_MESH

[ 9 -eq "$k_strict_mode" ] || exit 1
[ -s "$NETWORK_NODES" ] || exit 1

THIS_NODE_NAME=$(cat $NETWORK_NODES |grep "$MY_MESH_IP" |awk '{print $3}')
if echo $THIS_NODE_NAME |grep -q '@@' ; then
	MY_GROUP=$(echo $THIS_NODE_NAME |awk -F @@ '{print $2}' |tr [':'] [' '])
	group_key=1
else
	MY_GROUP=$(cat $NETWORK_NODES |grep "$MY_MESH_IP" |awk '{print $5}' |tr [':'] [' ']) 
	group_key=2
fi
[ -n "$MY_GROUP" ] || { echo "no group to join" ; exit; } 

for group  in $MY_GROUP; do
	while read RECORD ; do
		case $group_key in
			1) 
				NODE_NAME=$(echo $RECORD |awk '{print $3}')
				BELONG_TO=$(echo $NODE_NAME |awk -F @@ '{print $2}') ;;
			2) 
				BELONG_TO=$(echo $RECORD |awk '{print $5}') ;;
		esac
		echo $BELONG_TO |grep -q "$group" && {
			ALLOWED_IP=$(echo $RECORD |awk '{print $2}')
			ALLOWED_MAC=$(echo $RECORD |awk '{print $4}')
			echo "$ALLOWED_MAC $ALLOWED_IP">> $TEMP_GROUP_MESH
		}
	done < $NETWORK_NODES
done

cat $TEMP_GROUP_MESH |sort -u > $GROUP_MESH
[ "$(cat $GROUP_MESH |wc -l)" -gt 1 ] || rm -f $GROUP_MESH
#
