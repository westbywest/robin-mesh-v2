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
CONF=cp_switch
k_restart=0

echo "processing UCI file: $CONF"
while read riga ; do
	SECTION_OPTION=$(echo $riga | awk '{print $1}')
	option="${CONF}.${SECTION_OPTION}"	
	VALUE=$(echo $riga | awk '{print $2}')	
			
	case $SECTION_OPTION in
		"main.which_handler")
			CURRENT_VALUE=$(uci get ${option})
			[ "$CURRENT_VALUE" -eq "$VALUE" ] || {
				k_restart=1
				uci set $option=${VALUE}
        		uci commit cp_switch 
			}
		;;
	esac		
					
done < $WDIR/cp_switch

[ 1 -eq "$CALLER" ] && {
	if [ "$k_restart" -eq 1 ] ; then
        uci set flags.restart.system="1"
        uci commit flags
	fi
}
#
