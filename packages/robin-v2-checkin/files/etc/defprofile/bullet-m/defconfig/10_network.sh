#!/bin/sh

cat > $NETWORK_CONF << network_end
config interface loopback
	option ifname  lo
	option proto   static
	option ipaddr  127.0.0.1
	option netmask 255.0.0.0

config interface mesh
	option ifname  wlan0
	option proto   static
	option ipaddr  ${mesh_ipaddr}
	option netmask 255.0.0.0

config interface ap1
	option ifname  wlan1
	option proto   static
	option ipaddr  192.168.2.1
	option netmask 255.255.255.0

config interface lan
	option ifname  eth0
	option proto   static
	option ipaddr  192.168.1.1
	option netmask 255.255.255.0

network_end
