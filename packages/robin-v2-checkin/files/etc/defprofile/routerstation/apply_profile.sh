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

NETWORK_CONF="/tmp/network"
WIRELESS_CONF="/tmp/wireless"

# newline
N="
"
NO_EXPORT=1

append() {
	local var="$1"
	local value="$2"
	local sep="${3:- }"
	
	eval "export ${NO_EXPORT:+-n} -- \"$var=\${$var:+\${$var}\${value:+\$sep}}\$value\""
}

hex2dec() {
	my_MAC=$(uci get node.general.myMAC)
	local i=$1
	let x=0x$(echo $my_MAC | cut $i)
	echo $x
}

RADIOS=$(ls -d /sys/class/ieee80211/phy* |wc  -l) 
[ "$RADIOS" -lt 2 ] && reboot

[ -s $NETWORK_CONF ] && rm -f $NETWORK_CONF
[ -s $WIRELESS_CONF ] && rm -f $WIRELESS_CONF

uci batch <<EOF
set node.general.ethPorts=2
set node.general.wanPort=eth0
set node.general.lanPort=eth1
commit node
EOF

for defconfig_source_file in /etc/defprofile/routerstation/defconfig/*; do
	. $defconfig_source_file
done

#
