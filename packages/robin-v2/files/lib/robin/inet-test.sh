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

#/lib/robin/inet-test.sh 

[ 1 -eq "$(uci get management.enable.stand_alone_mode)" ] && { echo "0"; exit; } 

IFS=\;
set ${CHKIP:-198.41.0.4;192.33.4.12;128.8.10.90;192.5.5.241;192.36.148.17;192.58.128.30;193.0.14.129;198.32.64.12;202.12.27.33}
unset IFS

cnt=0
while [  $cnt -lt 3 ]; do
	random=$(hexdump -d -n2 /dev/urandom | awk 'NF > 1 {print (($2 % 9) + 1)}')
	eval $(echo "ip=\$$random")

	TEST_IP="${TEST_IP} $ip"
	let cnt=cnt+1 
done

TEST_DOMAIN="checkin.open-mesh.com www.google.com www.yahoo.com www.alltheweb.com"
wget_options="-t 1 -T 5 --spider"

passed() {
	case $1 in
		1) testWas="traceroute";;
		2) testWas="wget test domains";;
		3) testWas="fping test domains";;
		4) testWas="fping: $2 $3 $4";;
	esac

	logger -st ${0##*/} "passed: $testWas"
	echo "0"
 	exit 
}

#...........fping - IP-oriented (3 of 9 random)
nTest=4
[ $(fping -a $TEST_IP 2>/dev/null |wc -l) -gt 0 ] && {	echo "0";	exit; } 
logger -st ${0##*/} "failed (f)pinging $TEST_IP";

#...........wget - spider
nTest=2
for DOMAIN in $TEST_DOMAIN ; do
	wget $wget_options "http://${DOMAIN}" > /dev/null 2>&1 && passed $nTest
done
logger -st ${0##*/} "failed wgetting $TEST_DOMAIN ";

#we don't have internet
echo "1"
#
