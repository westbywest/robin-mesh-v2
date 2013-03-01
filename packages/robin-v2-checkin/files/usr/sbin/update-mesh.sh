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

# /usr/sbin/update-mesh.sh 

CALLER=$1
CALLER="${CALLER:-1}"
CONF=mesh
WDIR=/etc/update
k_restart=0

echo "processing UCI file: mesh, part 1"
while read riga ; do

	SECTION_OPTION=$(echo $riga | awk '{print $1}')
	VALUE=$(echo $riga | awk '{print $2}')
	
	if [ "$VALUE" -eq 1 -o "$VALUE" -eq 0 ] ; then
		case $SECTION_OPTION in
			"Myap.up")
				option="${CONF}.${SECTION_OPTION}"
				CURRENT_VALUE=$(uci get ${option})
				if ! [ "$CURRENT_VALUE" == "$VALUE" ] ; then
					uci set $option=$VALUE
					uci commit mesh
					k_restart=1
				fi
			;;
	
			"ap.psk")
				WPA_AP1="none"
				[ "$VALUE" -eq 1 ] && WPA_AP1="psk" 
				
				CURRENT_VALUE=$(uci get mesh.ap.encryption)
				if ! [ "$CURRENT_VALUE" == "$WPA_AP1" ] ; then
					uci set mesh.ap.encryption=$WPA_AP1
					uci commit mesh
					k_restart=1					
				fi
			;;	
		esac
	fi

done < $WDIR/mesh

[ 1 -eq "$CALLER" ] && {
	if [ "$k_restart" -eq 1 ] ; then
		uci set flags.restart.system="1"
		uci commit flags	
	fi
}
#
