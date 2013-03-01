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

# /usr/sbin/update-general.sh 

CALLER=$1
CALLER="${CALLER:-1}"
WDIR=/etc/update
CONF=general

k_upstream="0:0"
k_name_srv=0
k_public_ns=0

echo "processing UCI file: $CONF"
while read riga ; do
	SECTION_OPTION=$(echo $riga | awk '{print $1}')
	option="${CONF}.${SECTION_OPTION}"	
	VALUE=$(echo $riga | awk '{print $2}')	
	
	case $SECTION_OPTION in
  		"services.ntpd_srv"|"services.updt_srv"|"services.cstm_srv"|"services.via_proxy"|"services.checker")
			[ -n "$VALUE" ] && uci set $option=${VALUE} 
		;;
 
  		"services.base_test"|"services.base_beta")
			[ -n "$VALUE" ] && uci set $option=${VALUE} 
		;;

    		"services.upstream")
			CURRENT_VALUE=$(uci get ${option})
			VALUE="${VALUE:-0}"
			k_upstream="${CURRENT_VALUE}:${VALUE}"
			if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
				uci set $option=${VALUE} 
			fi
		;;
						
    		"services.name_srv")
			CURRENT_VALUE=$(uci get ${option})
			if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
				uci set $option=${VALUE} 
				k_name_srv=1
			fi
		;;

	esac		
					
done < $WDIR/general
uci commit general

[ 1 -eq "$CALLER" ] && {
	if [ 1 -eq "$k_public_ns" ]; then
		/etc/init.d/nameserver config

	else
		case $k_upstream in
			"1:0"|"0:1") /etc/init.d/nameserver config ;;
			"1:1") [ 1 -eq "$k_name_srv" ] && /etc/init.d/nameserver config ;;
		esac
	fi
}
#

