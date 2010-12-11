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

# /usr/sbin/update-management.sh 

CALLER=$1
CALLER="${CALLER:-1}"
WDIR=/etc/update
CONF=management
k_restart=0
check_upgrade_window=0
SI="1"
NO="0"

isnumber() {
	if expr $1 + 1 &> /dev/null ; then
		echo $1
	else
		echo 0
	fi
}

use_public_dns() {
	local n=$1

	case $n in
		1) PUBLIC_DNS="opendns" ;;
		2) PUBLIC_DNS="familyshield" ;;
		3) PUBLIC_DNS="google" ;;
		4) PUBLIC_DNS="scrubit" ;;
		5) PUBLIC_DNS="dnsadvantage" ;;
		*) PUBLIC_DNS="opendns" ;;
	esac

	ns1=$(uci get dns".${PUBLIC_DNS}."nameserver1)
	ns2=$(uci get dns".${PUBLIC_DNS}."nameserver2)
	
	cat > /tmp/resolv.conf <<-resolvers
		nameserver $ns1
		nameserver $ns2
		nameserver 127.0.0.1	
	resolvers

	echo "use "$PUBLIC_DNS" public DNS"
}

echo "processing UCI file: $CONF"
while read riga ; do
	SECTION_OPTION=$(echo $riga | awk '{print $1}')
	VALUE=$(echo $riga | awk '{print $2}')
	
	if ! [ -z $VALUE ] ; then
		option="${CONF}.${SECTION_OPTION}"

		if [ "$SECTION_OPTION" == "enable.base" ] ; then
			uci set $option=$VALUE
			uci commit management

			case $VALUE in
				"trunk") upgd_srv=$(uci get general.services.base_test) ;;
				"beta") upgd_srv=$(uci get general.services.base_beta) ;;	
			esac
			[ -n "$upgd_srv" ] && {
				uci set general.services.upgd_srv=$upgd_srv
				uci commit general	
			}	
		fi
	
		case $SECTION_OPTION in
			"enable.custom_update")
				if [ "$VALUE" -eq 1 -o "$VALUE" -eq 0 ] ; then
					uci set $option=${VALUE} 
					uci commit management
				fi
			;;
				
			"enable.rootpwd")
				CURRENT_VALUE=$(uci get ${option})
				[ "$CURRENT_VALUE" == "$VALUE" ] || {
				(echo -n $VALUE && sleep 1 && echo -n $VALUE) | passwd root
				uci set management.enable.rootpwd=$VALUE
				uci commit management
				/etc/init.d/rc.httpd restart
				}
			;;
			
			"enable.bridge"|"enable.ap2hidden")
				CURRENT_VALUE=$(uci get ${option})
				if [ "$VALUE" -eq 1 -o "$VALUE" -eq 0 ] ; then
					if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
						uci set $option=$VALUE
						uci commit management
						k_restart=1
					fi
				fi
			;;			
			
			"enable.https"|"enable.method_POST")	
				CURRENT_VALUE=$(uci get ${option})
				if [ "$VALUE" -eq 1 -o "$VALUE" -eq 0 ] ; then
					if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
						uci set $option=$VALUE
						uci commit management
					fi
				fi					
			;;
			
			"enable.update_rate")	
				CURRENT_VALUE=$(uci get ${option})
				if [ "$VALUE" -ge 5 -a "$VALUE" -le 30 ] ; then
					if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
						uci set $option=$VALUE
						uci commit management
						/etc/init.d/timing stop
						sleep 3
						/etc/init.d/timing start
					fi
				fi					
			;;			
			

			"enable.freeze_version")	
				if [ "$VALUE" -eq 1 -o "$VALUE" -eq 0 ] ; then			
					uci set $option=${VALUE}
					case $VALUE in
						1) uci set management.enable.upgrade="0" ;;
						0) uci set management.enable.upgrade="1" ;;						
					esac	
					uci commit management
				fi
			;;			
			
			"enable.sm")	
				CURRENT_VALUE=$(uci get management.enable.strict_mesh)
				STRICT_MESH_STATE="${CURRENT_VALUE}:${VALUE}"
				case $STRICT_MESH_STATE in
					'1:0'|'0:1')
						uci set management.enable.strict_mesh=$VALUE
						uci commit management
						/lib/robin/strict-mesh.sh
						;;
					*)
						: #no-op
						;;		
				esac			
			;;			
			
			"enable.gmt_offset")	
				CURRENT_VALUE=$(uci get ${option})
				[ 4 -eq "$(uci get cp_switch.main.which_handler)" ] && VALUE="0"
				if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
					uci set $option=$VALUE
					uci commit management
				fi		
				if [ 0 -eq "$VALUE" ] ; then
	 				TimeZone="GMT+0"
				else
					gmt_offset=$VALUE 
					clock_offset=$(echo $gmt_offset |awk '{printf( "%i\n", $1 *(-1))}')
					[ "$clock_offset" -ge 0 ] && clock_offset="+${clock_offset}"
					TimeZone="GMT${clock_offset}"
				fi
				echo "$TimeZone" > /etc/TZ
			;;					

			"enable.upgrade_f")	
				CURRENT_VALUE=$(uci get ${option})
				ULW=$VALUE
				[ "$CURRENT_VALUE" == "$VALUE" ] ||	check_upgrade_window=1
			;;	

			"enable.upgrade_t")	
				CURRENT_VALUE=$(uci get ${option})
				UUW=$VALUE
				[ "$CURRENT_VALUE" == "$VALUE" ] ||	check_upgrade_window=1
			;;

			"enable.force_reboot")	
				CURRENT_VALUE=$(uci get ${option})
				if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
					uci set $option=$VALUE
					uci commit management
					sleep 1
					/lib/robin/sched-reboot.sh
				fi
			;;

			"enable.wake_slowly")
				VALUE=$(echo $VALUE |sed 's/ //g') 
				VALUE=${VALUE:-0}
				v=$(isnumber $VALUE)
				uci set $option=${v} 
			;;

			"enable.shaper")
				CURRENT_VALUE=$(uci get ${option})
				if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
					if [ "$VALUE" -ge 0 -a "$VALUE" -le 2 ]; then 
						uci set $option=$VALUE
						uci commit management
						k_restart=1
					fi
				fi	
			;;

			"enable.proxy")
				if [ "$VALUE" -eq 0 -o "$VALUE" -eq 1 ]; then
					CURRENT_VALUE=$(uci get ${option})
					if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
 						uci set $option=$VALUE
						uci commit management
						k_restart=1
					fi
				fi	
			;;

			"enable.httpd_auth"|"enable.httpd_passwd")
				CURRENT_VALUE=$(uci get ${option})
				if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
					uci set $option=$VALUE
					uci commit management
					[ 1 -eq "$CALLER" ] && {
						/etc/init.d/rc.httpd stop
						sleep 1
						/etc/init.d/rc.httpd start
					}
				fi	
			;;

			"enable.lwp_over_dash")
				CURRENT_VALUE=$(uci get ${option})
				if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
					uci set $option=$VALUE
					uci commit management
				fi	
			;;

			"enable.local_domain")
				CURRENT_VALUE=$(uci get ${option})
				[ "$CURRENT_VALUE" = "$VALUE" ] || {
					uci set $option=$VALUE
					uci commit management
					k_restart=1
				}
			;;

			"enable.stand_alone_mode")
				CURRENT_VALUE=$(uci get ${option})
				[ "$CURRENT_VALUE" = "$VALUE" ] || {
					uci set $option=$VALUE
					uci commit management
				}
			;; 

			"enable.sag_mode_interval")
				CURRENT_VALUE=$(uci get ${option})
				[ "$CURRENT_VALUE" = "$VALUE" ] || {
					uci set $option=$VALUE
					uci commit management
				}
			;; 

			"enable.public_dns")
				CURRENT_VALUE=$(uci get ${option})
				[ "$CURRENT_VALUE" == "$VALUE" ] || {
					[ -n "$VALUE" ] || VALUE=1
					uci set $option=$VALUE
					uci commit management
					use_public_dns $VALUE
				}
			;;

			"enable.country_code")
				CURRENT_VALUE=$(uci get ${option})
				[ "$CURRENT_VALUE" = "$VALUE" ] || {
					uci set $option=$VALUE
					uci commit management
					k_restart=1
				}
			;;

		esac			
	fi		
done < $WDIR/management

if [ 1 -eq "$check_upgrade_window" ] ; then
	if [ "$ULW" -ge 0 -a "$ULW" -le 23 ] ; then
		if	[ "$UUW" -ge 0 -a "$UUW" -le 23 ] ; then
			if [ "$UUW" -ge "$ULW" ] ; then
				uci set management.enable.upgrade_f=$ULW
				uci set management.enable.upgrade_t=$UUW
				uci commit management

				if [ "$k_restart" -eq 0 ] ; then
					/etc/init.d/timing stop
					sleep 1
					/etc/init.d/timing start	
				fi		
		
			fi
		fi
	fi	
fi

[ 1 -eq "$CALLER" ] && {
	if [ "$k_restart" -eq 1 ] ; then 
		uci set flags.restart.system="1"
		uci commit flags
	fi
}
#

