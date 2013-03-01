#!/bin/sh
# /usr/sbin/update-ethers.sh

CALLER=$1
CALLER="${CALLER:-1}"
WDIR=/etc/update

[ -e /etc/ethers ] || touch /etc/ethers

curr_ethers_md5=$(md5sum /etc/ethers |awk '{print $1}')
rcvd_ethers_md5=$(md5sum $WDIR/ethers |awk '{print $1}')

[ "$curr_ethers_md5" == "$rcvd_ethers_md5" ] || {
	cp -s $WDIR/ethers /etc/ethers

	/etc/init.d/dhcpd stop
	sleep 1
	/etc/init.d/dhcpd start
}
#
