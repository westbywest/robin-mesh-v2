#!/bin/sh 

WAN_PORT=$(uci get node.general.wanPort)
PREDEF_ROLE=$(uci get installation.node.predef_role)

prepare() {
	local interface=$1

# READONLY
#	ifconfig $interface up
#	iptables -I INPUT -i $interface  -p udp --destination-port 67:68 --source-port 67:68 -s 101.0.0.0/8 -j DROP
	logger 55_detect_role brings up WAN port as local interface
	sleep 1
}
	
lease_request() {
	local interface=$1

# READONLY
#	found_dhcp=0
#	/sbin/udhcpc -i $interface -t 10 -n -s /usr/share/udhcpc/robin.script
	logger 55_detect_role starts udhcpc
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
# READONLY
#		killall -9 udhcpc
		logger 55_detect_role kills udhcpc
		;;
esac

uci set node.general.role=$ROLE
uci commit node
#

