#!/bin/sh

get_hostname() {
	IP_mesh=$(uci get node.general.IP_mesh)
	while read r ; do
		NODE_IP=$(echo $r |awk '{print $2}')	
		[ "$IP_mesh" == "$NODE_IP" ] && {
			HOST_NAME=$(echo $r |awk '{print $3}'|tr -d '\n\r\v' |tr [*] ['_'] |sed  s/"'"//g )	

# READONLY
#			uci set system.@system[0].hostname=$HOST_NAME
#			uci commit system
#			echo "$HOST_NAME" > /proc/sys/kernel/hostname
			break
		}
	done < /etc/update/nodes
}

#[ -e /etc/update/nodes ] && get_hostname
