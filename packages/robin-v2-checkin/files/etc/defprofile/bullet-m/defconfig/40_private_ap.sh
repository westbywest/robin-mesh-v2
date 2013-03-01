#!/bin/sh

[ "$(uci get mesh.Myap.up)" -eq 1 ] || exit 0

#arrange wifi and network for privet AP
MyAP_NET=$(uci get mesh.Myap.net)
MyAP_PREFIX=$(uci get mesh.Myap.prefix)
private_hidden=$(uci get management.enable.ap2hidden)
private_ssid="$(uci get mesh.Myap.ssid |tr [*] [' '])"
private_encryption=$(uci get mesh.Myap.encryption)
private_key=$(uci get mesh.Myap.key)

IP_Myap="${MyAP_NET}.$(hex2dec -c13-14).$(hex2dec -c16-17)"
ap2_ipaddr="${IP_Myap}.1"
Myap_s_lease="${IP_Myap}.10"
Myap_e_lease="${IP_Myap}.250"	

echo "${Myap_s_lease},${Myap_e_lease},255.255.255.0,2h" > /tmp/private_pool
IP_Myap="${ap2_ipaddr}/${MyAP_PREFIX}"
	
cat >> $NETWORK_CONF <<-private_ap_network
config interface ap2
	option ifname   wlan2
	option proto    static
	option ipaddr   ${ap2_ipaddr}
	option netmask  255.255.255.0

private_ap_network

cat >> $WIRELESS_CONF <<-private_ap_wireless
config wifi-iface private
	option device   radio0
	option network  ap2
	option mode     ap
	option hidden   ${private_hidden}
	option ssid     ${private_ssid}
	option encryption ${private_encryption}
	option key      ${private_key}

private_ap_wireless

uci set node.general.IP_Myap=$IP_Myap
uci commit node
