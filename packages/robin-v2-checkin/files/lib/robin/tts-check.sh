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

# /lib/robin/tts-check.sh

mesh_ifname=$(uci -P /var/state get mesh.iface.ifname)
cur_channel=$(uci get radio.channel.current)
alt_channel=$(uci get radio.channel.alternate)
	
NOW=$(echo $(date +%s) | awk '{printf( "%i\n", $1/60)}')
K_REBOOT=0

cumulative_log () {
	echo "mark" >> /tmp/tts-check.log
	if [ "$(cat /tmp/tts-check.log |wc -l)" -gt 10 ] ; then
		logger -st ${0##*/} "cumulative message: last 10 checks were ok"
		echo "mark" > /tmp/tts-check.log
	fi
}
	
switch_channel () {
# READONLY
#	uci set radio.channel.current=$alt_channel
#	uci set radio.channel.tts="0"		 
#	uci commit radio
#	REASON=13 ; K_REBOOT=1
}

#check channel drift
[ "$cur_channel" -eq "$(uci get wireless.radio0.channel)" ] || {
	REASON=10
# READONLY	
#	/sbin/do_reboot $REASON
}

#check missed channel switch signal
dash_alt_channel=
[ -e /etc/update/received ] && dash_alt_channel=$(cat /etc/update/received |grep 'channel.alternate' |awk '{print $2}') 
if [ -n "$dash_alt_channel" -a \
        "$dash_alt_channel" -ne "$alt_channel" ]; then

	alt_channel=$dash_alt_channel
# READONLY
#	uci set radio.channel.alternate=$alt_channel 
#	uci commit radio
#	switch_channel
fi

#switch working channel
# READONLY
#if ! [ "$cur_channel" -eq "$alt_channel" ] ; then
#	AT=$(uci get radio.channel.tts)
#	[ "$NOW" -ge "$AT" ] && switch_channel
#	WAIT=$(echo $AT $NOW | awk '{printf( "%i\n", ($1 - $2))}')
#	logger -st ${0##*/} "channel switch in $WAIT minutes"
#fi

# READONLY
#if [ "$K_REBOOT" -eq 1 ] ; then 
#	/sbin/do_reboot $REASON
#fi

cumulative_log
exit 0
#
