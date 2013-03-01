#!/bin/sh

OLD_REPLY=/etc/update/received.old

[ -e "$OLD_REPLY" ] && {
# READONLY
#	DASHBOARD_CHANNEL=$(cat $OLD_REPLY |grep "channel.alternate" |awk '{print $2}') 
#	[ -n "$DASHBOARD_CHANNEL" ] || DASHBOARD_CHANNEL=5 
#	uci set radio.channel.alternate=$DASHBOARD_CHANNEL
#	uci set radio.channel.current=$DASHBOARD_CHANNEL
#	uci set radio.channel.tts="0"
#	uci commit radio
}

# READONLY
#CHANNEL=$(uci get radio.channel.current)	
#uci set wireless.radio0.channel=$CHANNEL
#uci commit wireless
#
