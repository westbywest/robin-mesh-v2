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

# /usr/sbin/update-radio.sh 

CALLER=$1
CALLER="${CALLER:-1}"
WDIR=/etc/update
CONF=radio
mesh_ifname=$(uci -P /var/state get wireless.mesh.ifname)

echo "processing UCI file: $CONF"
if [ "$CALLER" -eq 1 ] ; then
	SHOULD_CHANGE=0
	real_channel=$(iwgetid ${mesh_ifname} -rc)
	tts=$(uci get radio.channel.tts)

	while read riga ; do
		SECTION_OPTION=$(echo $riga | awk '{print $1}')
		option="${CONF}.${SECTION_OPTION}"	
		VALUE=$(echo $riga | awk '{print $2}')

			case $SECTION_OPTION in
				"channel.alternate")
					old_value=$(uci get ${option})
					if [ "$old_value" -eq "$VALUE" ]; then
						#time_to_switch=0 BUT dashboard-ch and working-ch are not in sync 
						[ "$tts" -eq 0 -a "$real_channel" -ne $VALUE ] && SHOULD_CHANGE=1

					else
						SHOULD_CHANGE=1
					fi
         			;;
			esac

	done < $WDIR/radio

	[ 1 -eq "$SHOULD_CHANGE" ] && {
		AT=$(echo $(date +%s) | awk '{printf( "%i\n", ($1 + 1500 )/60)}')
		uci set radio.channel.tts=$AT									
		uci set radio.channel.alternate="${VALUE}" 
		uci commit radio
	}
fi
#
