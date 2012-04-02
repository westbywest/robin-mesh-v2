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

# /usr/sbin/update-node.sh

CALLER=$1
CALLER="${CALLER:-1}"
WDIR=/etc/update
CONF=node

echo "processing UCI file: $CONF"	
while read riga ; do
	SECTION_OPTION=$(echo $riga | awk '{print $1}')
	option="${CONF}.${SECTION_OPTION}"			
	VALUE=$(echo $riga | awk '{print $2}')
		
	if ! [ -z $VALUE ] ; then
		case $SECTION_OPTION in
			"general.net")
				hereNet=$(echo $VALUE |tr [A-Z] [a-z] |tr [*] ['_']  |sed  s/"'"//g |sed "s/(//g" |sed "s/)//g")
				uci set $option="${hereNet}"
				uci commit node
			;;
		esac
	fi	
done < $WDIR/node
#
