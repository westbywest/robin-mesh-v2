#!/bin/sh

AP_NET=$(uci get mesh.ap.net)
AP_PREFIX=$(uci get mesh.ap.prefix)
MESH_NET=$(uci get mesh.iface.net)

mesh_ipaddr="${MESH_NET}.$(hex2dec -c10-11).$(hex2dec -c13-14).$(hex2dec -c16-17)"

IP_ap="${AP_NET}.$(hex2dec -c13-14).$(hex2dec -c16-17)"
ap1_net="${IP_ap}.0" 
ap1_ipaddr="${IP_ap}.1"
ap_s_lease="${IP_ap}.10"
ap_e_lease="${IP_ap}.250"

cat > $NETWORK_CONF << network_end
config interface loopback
	option ifname  lo
	option proto   static
	option ipaddr  127.0.0.1
	option netmask 255.0.0.0

config interface wan
	option ifname  eth0
	option proto   static
	option ipaddr  192.168.88.1
	option netmask 255.255.0.0

config interface lan
	option ifname  eth1
	option type    bridge
	option proto   static
	option ipaddr  ${ap1_ipaddr}
	option netmask 255.255.255.0

config interface mesh
	option ifname  wlan0
	option proto   static
	option ipaddr  ${mesh_ipaddr}
	option netmask 255.0.0.0

network_end

#prepare dhcp public pool
echo "${ap_s_lease},${ap_e_lease},255.255.255.0,2h" > /tmp/public_pool
#set up hosts
[ "$(cat /etc/hosts |grep -c "my.robin-mesh.com")" -eq 0 ] && echo "$ap1_ipaddr my.robin-mesh.com" >> /etc/hosts
#update UCI node
uci set node.general.IP_mesh=$mesh_ipaddr
uci set node.general.IP_ap="${ap1_ipaddr}/${AP_PREFIX}"	
uci commit node
#set up captive-portal interface
uci batch <<-EOF_cp
	set cp_switch.main.iface="br-lan"
	set cp_switch.main.iface_ip=$ap1_ipaddr
	set cp_switch.main.iface_net=$ap1_net
	set cp_switch.main.iface_mask="255.255.255.0"	
	set cp_switch.main.start_lease=$ap_s_lease
	commit cp_switch	
EOF_cp
#
