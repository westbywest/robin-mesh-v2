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

# /usr/sbin/update-wifi.sh

CALLER=$1
CALLER="${CALLER:-1}"
WDIR=/etc/update
k_restart=0

echo "processing UCI file: mesh, part 2"
while read riga ; do
	SECTION_OPTION=$(echo $riga | awk '{print $1}')
	VALUE=$(echo $riga | awk '{print $2}')
	
	case $SECTION_OPTION in
		"public.ssid")
			echo $VALUE |grep -q '@@' && VALUE=$(echo $VALUE |awk -F @@ '{print $1}')

			CURRENT_VALUE=$(uci get mesh.ap.ssid)
			if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
				uci set mesh.ap.ssid=$VALUE
				uci commit mesh
				k_restart=1 #buggy madwifi (on-the-fly ssid changes may change frequency too)
			fi					
			;;
			
		"private.ssid")
			if [ "$(uci get mesh.Myap.up)" -eq 1 ] ; then
				
				CURRENT_VALUE=$(uci get mesh.Myap.ssid)			
				if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
					uci set mesh.Myap.ssid=$VALUE
					uci commit mesh
					k_restart=1 #buggy madwifi
				fi
			fi
			;;
				
		"public.key")
			if [ "$(uci get mesh.ap.encryption)" == "psk" ] ; then		
				CURRENT_VALUE=$(uci get mesh.ap.key)
				if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
					uci set mesh.ap.key=$VALUE
					uci commit mesh
					k_restart=1
				fi
			fi
			;;	
					
		"private.key")
			if [ "$(uci get mesh.Myap.up)" -eq 1 ] ; then
				CURRENT_VALUE=$(uci get mesh.Myap.key)		
				if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
					uci set mesh.Myap.key=$VALUE
					uci commit mesh
					k_restart=1
				fi
			fi
			;;	
	esac

done < $WDIR/wireless
	
[ 1 -eq "$CALLER" ] && {
	if [ "$k_restart" -eq 1 ] ; then
		uci set flags.restart.system="1"
		uci commit flags
	fi
}
#
