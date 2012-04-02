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

my_MAC=$(uci get node.general.myMAC)
AP_IF=$(uci get network.ap1.ifname)
AP_NET=$(uci get mesh.ap.net)
AP_PREFIX=$(uci get mesh.ap.prefix)

hex2dec() {
	local i=$1
	let x=0x$(echo $my_MAC | cut $i)
	echo $x
}

get_IP4() {
	IP_ap="${AP_NET}.$(hex2dec -c13-14).$(hex2dec -c16-17)"	
	ap1_ipaddr="${IP_ap}.1"
	ap1_net="${IP_ap}.0" 
	ap_s_lease="${IP_ap}.10"
	ap_e_lease="${IP_ap}.250"

	echo "${ap_s_lease},${ap_e_lease},255.255.255.0,2h" > /tmp/public_pool
	IP_ap="${ap1_ipaddr}/${AP_PREFIX}"	
		
	uci set node.general.IP_ap=$IP_ap		
	uci commit node
}

if [ 1 -eq "$(uci get node.general.role)" ] ; then	
	public_iface=$AP_IF	
	LAN_PORT=$(uci get node.general.lanPort) 
	ipaddr=$(ifconfig $LAN_PORT | grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}')
	netmask=$(ifconfig $LAN_PORT | grep 'Mask:'| cut -d: -f4)
	#
	uci set network.lan.ipaddr=$ipaddr	
	uci set network.lan.netmask=$netmask				
	uci commit network
	
else
	public_iface="br-lan"	
fi
uci set cp_switch.main.iface=$public_iface ; uci commit cp_switch

get_IP4

[ "$(cat /etc/hosts |grep -c "my.robin-mesh.com")" -eq 0 ] && {
	echo "$ap1_ipaddr my.robin-mesh.com" >> /etc/hosts
}

if [ 1 -eq "$(uci get node.general.role)" ] ; then
	uci set wireless.public.network="ap1"
	uci commit wireless

	uci del network.lan.type		
	uci set network.ap1.ipaddr=$ap1_ipaddr	
	uci set network.ap1.netmask="255.255.255.0"
	uci commit network

else 
	uci set wireless.public.network="lan"
	uci commit wireless

	uci set network.lan.type="bridge"
	uci set network.lan.ipaddr=$ap1_ipaddr	
	uci set network.lan.netmask="255.255.255.0"	
	uci del network.ap1.ipaddr		
	uci del network.ap1.netmask
	uci commit network
fi

#captive_portal settings
uci batch << EOF_cp
set cp_switch.main.iface_ip=$ap1_ipaddr
set cp_switch.main.iface_net=$ap1_net
set cp_switch.main.iface_mask="255.255.255.0"	
set cp_switch.main.start_lease=$ap_s_lease
commit cp_switch	
EOF_cp
#
