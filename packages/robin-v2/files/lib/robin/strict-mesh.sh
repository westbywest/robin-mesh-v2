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

#/lib/robin/strict-mesh.sh
# allowing mesh only amomg nodes which belong to the same network name

k_strict_mode=$(uci get management.enable.strict_mesh)
MESH_IFACE=$(uci -P /var/state get mesh.iface.ifname)

if [ -e /tmp/clean_mesh_rules ] ; then
	sh /tmp/clean_mesh_rules
	rm -f /tmp/clean_mesh_rules
fi

case $k_strict_mode in
	0) exit ;;
	1) BEING_ALLOWED="/etc/update/network_nodes" ;;
	9) BEING_ALLOWED="/var/run/limited.mesh" ;;
esac
[ -s "$BEING_ALLOWED" ] || exit 1

#start allowing
iptables -I INPUT -i $MESH_IFACE -p udp --dport 698 -j DROP 
echo "iptables -D INPUT -i $MESH_IFACE  -p udp --dport 698 -j DROP" >> /tmp/clean_mesh_rules

while read RECORD ; do
	ALLOWED_IP="$(echo $RECORD |awk '{print $2}')/32"
	iptables -I INPUT -i $MESH_IFACE -s $ALLOWED_IP -j ACCEPT	
	echo	"iptables -D INPUT -i $MESH_IFACE -s $ALLOWED_IP -j ACCEPT" >> /tmp/clean_mesh_rules	

	logger -st ${0##*/} "$ALLOWED_IP added to the mesh white-list"	
done < $BEING_ALLOWED

exit	0
#
