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

# /usr/sbin/update-nodogsplash.sh 

CALLER=$1
CALLER="${CALLER:-1}"
WDIR=/etc/update

echo "processing nodogsplash configuration file"
### configuration file
if [ -e $WDIR/nodog ] ; then	
	ndsconf="/etc/nodogsplash/nodogsplash.conf"

	#we do not use sed 'cos lines start with spaces
	cat $ndsconf |grep -v Firewall |grep -v "}" |grep -v GatewayInterface > /tmp/nodog_current
	ncmd5=$(md5sum /tmp/nodog_current |awk '{print $1}')	

	sed -e '/^$/d' $WDIR/nodog |sed -e '/^Firewall/d' |sed -e '/^}/d' |sed -e '/^#/d' > /tmp/nodog_recvd
	nrmd5=$(md5sum /tmp/nodog_recvd |awk '{print $1}')	

	if ! [ "$ncmd5" == "$nrmd5" ] ; then
		cp -f /tmp/nodog_recvd /etc/cp.conf/nodogsplash.body	
		uci set flags.restart.cps="1"
		uci commit flags
	fi
fi

### htdocs files
[ 0 -eq "$CALLER" ] && exit #we don't have inet access
[ -e $WDIR/splash-HTML ] || exit
 
#check if splash page has been edited
page_id=$(uci get cp_switch.handler_1.page_id) 
splash_page_id=$(cat $WDIR/splash-HTML |grep 'page_id' |awk '{print $2}')
[ "$page_id" -eq "$splash_page_id" ] && exit
uci set cp_switch.handler_1.page_id=$splash_page_id
uci commit cp_switch

current_dir=$(pwd)
first_occurence=1	
logger -st ${0##*/} "update nds splash page"	
rm -f /tmp/update.failures

echo "processing splash page"
while read riga ; do

	SECTION_OPTION=$(echo $riga | awk '{print $1}')
	VALUE=$(echo $riga | awk '{print $2}')

	if ! [ -z $VALUE ] ; then
		case $SECTION_OPTION in
			page) 
				cd /tmp
				wget $VALUE -O /tmp/splash.html
				[ "$?" -ne 0 ] && { uci set flags.status.RR="1"; uci commit flags; } 
				if [ -e /tmp/splash.html ] ; then
					if cat /tmp/splash.html |grep "$authtarget" > /dev/null ; then
						cp -f /tmp/splash.html /etc/nodogsplash/htdocs
					fi
				fi
			;;
					
			image)
				cd /etc/nodogsplash/htdocs/images
				[ 1 -eq "$first_occurence" ] && {
					rm -f *
					first_occurence=0
				}
				URL=$(echo $riga |awk -F ! '{pippo = substr($1,7) ; print pippo}')
				wget -t 3 -T 60 "$URL"
				[ "$?" -ne 0 ] && { uci set flags.status.RR="1"; uci commit flags; } 
			;;
					
			file)
				cd /etc/nodogsplash/htdocs/pages
				wget -N $VALUE 
				[ "$?" -ne 0 ] && { uci set flags.status.RR="1"; uci commit flags;} 
				;;
		esac
	fi
done < $WDIR/splash-HTML
cd $current_dir
#


			
