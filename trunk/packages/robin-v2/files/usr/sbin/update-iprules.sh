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

# /usr/sbin/update-iprules.sh 

CALLER=$1
CALLER="${CALLER:-1}"
WDIR=/etc/update
CONF=iprules
k_restart=0
echo "processing UCI file: $CONF"
while read riga ; do

	SECTION_OPTION=$(echo $riga | awk '{print $1}')
	option="${CONF}.${SECTION_OPTION}"	
	VALUE=$(echo $riga | awk '{print $2}')	
	
	case $SECTION_OPTION in
	
		"filter.AP1_bridge")
			option="${CONF}.filter.AP1_isolation"
			CURRENT_VALUE=$(uci get ${option})
			if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
				uci set $option=$VALUE
				k_restart=1
			fi
		;;

		"filter.AP2_bridge")
			option="${CONF}.filter.AP2_isolation"
			CURRENT_VALUE=$(uci get ${option})
			if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
				uci set $option=$VALUE
				k_restart=1
			fi
		;;
	
		"filter.LAN_BLOCK2") # [0|1|101|102]
			option="${CONF}.filter.LAN_BLOCK"
			CURRENT_VALUE=$(uci get ${option})
			if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
				uci set $option=$VALUE
				k_restart=1
			fi
		;;
	
		"filter.ICMP_BLOCK")
			option="${CONF}.${SECTION_OPTION}"
			CURRENT_VALUE=$(uci get ${option})
			if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
				uci set $option=$VALUE
				k_restart=1
			fi
		;;
	
		"filter.enable_log"|"filter.log_server")
			option="${CONF}.${SECTION_OPTION}"
			CURRENT_VALUE=$(uci get ${option})
			if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
				uci set $option=$VALUE
				k_restart=1
			fi
		;;		

		"filter.SMTP_rdir")
			option="${CONF}.${SECTION_OPTION}"
			CURRENT_VALUE=$(uci get ${option})
			if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
				uci set $option=$VALUE
				k_restart=1
			fi
		;;

		"filter.SMTP_dest")
			option="${CONF}.${SECTION_OPTION}"
			CURRENT_VALUE=$(uci get ${option})
			if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
				uci set $option=$VALUE
				k_restart=1
			fi
		;;
		
		"filter.port_block")
			option="${CONF}.${SECTION_OPTION}"
			CURRENT_VALUE=$(uci get ${option})
			if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
				uci set $option=$VALUE
				k_restart=1
			fi
		;;


	esac
		
done < $WDIR/iprules
uci commit iprules

[ 1 -eq "$CALLER" ] && {
	if [ "$k_restart" -eq 1 ] ; then
		uci set flags.restart.system="1"
		uci commit flags	
	fi
}
#
