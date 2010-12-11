#!/bin/sh 

WAN_PORT=$(uci get node.general.wanPort)
PREDEF_ROLE=$(uci get installation.node.predef_role)

prepare() {
	local interface=$1

	ifconfig $interface up
	iptables -I INPUT -i $interface  -p udp --destination-port 67:68 --source-port 67:68 -s 101.0.0.0/8 -j DROP
	sleep 1
}
	
lease_request() {
	local interface=$1

	found_dhcp=0
	/sbin/udhcpc -i $interface -t 10 -n -s /usr/share/udhcpc/robin.script
	[ "$?" -eq 0 ] && found_dhcp=1
}

case $PREDEF_ROLE in
	0) found_dhcp=0 ;;
	*) { prepare $WAN_PORT; lease_request $WAN_PORT; } ;;
esac

[ 1 -eq "$found_dhcp" ] && { sleep 5; outgoing=$(/lib/robin/inet-test.sh); }
case "${found_dhcp}:${outgoing:-1}" in
	1:0)	
		ROLE=1 
		cp -f /tmp/resolv.conf.dhcp /www/resolvers.txt
		[ -e /www/xaa ] || {
			dd if=/dev/zero of=/www/xaa bs=1k count=50
		}
		;;

	*) 
		ROLE=0 
		killall -9 udhcpc
		;;
esac

uci set node.general.role=$ROLE
uci commit node
#

