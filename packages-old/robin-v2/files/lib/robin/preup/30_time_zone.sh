#!/bin/sh

if [ 4 -eq "$(uci get cp_switch.main.which_handler)" ] ; then
 	TimeZone="GMT+0"

else
	gmt_offset=$(uci get management.enable.gmt_offset) 
	clock_offset=$(echo $gmt_offset |awk '{printf( "%i\n", $1 *(-1))}')
	[ "$clock_offset" -ge 0 ] && clock_offset="+${clock_offset}"
	TimeZone="GMT${clock_offset}"
fi

echo "$TimeZone" > /etc/TZ
uci set system.@system[0].timezone=$TimeZone
uci commit system
