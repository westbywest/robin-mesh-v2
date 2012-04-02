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

# /lib/robin/blacklist.sh

ACTION=$1
BLACKLIST="/etc/blacklist/websites"

ipt() {
    opt=$1; shift
    echo "iptables -D $*" >> /var/run/blacklist.iptables
    iptables $opt $*
}

do_blacklist() {
	AP1_prefix=$(uci get mesh.ap.prefix)
	case $cp_HANDLER in
		4|5|6) AP1_iface=tun0 ;;
		*) AP1_iface=$(uci get cp_switch.main.iface) ;;
	esac

	ip=$(ip addr show $AP1_iface |grep 'inet' |awk '{print $2}')
	eval $(ipcalc -n $ip) ; AP1_net="${NETWORK}/${AP1_prefix}"

	rdr=$(cat $BLACKLIST | awk '$1=="REDIRECT_TO" {print $2}') 
	DEFAULT=$(nslookup $rdr |grep 'Address'|tail -1 |awk '{print $3}' | sed 's/,$//')

	for x in $(cat $BLACKLIST |grep -v ^# |grep -v 'REDIRECT_TO' |awk '{print $1}') ; do
		if [ -n "$x" ] ; then
			nslookup $x 2>&1 >/dev/null
			if [ $? -eq 0 ] ; then
  				ip=$(nslookup $x |grep 'Address'|tail -1 |awk '{print $3}' | sed 's/,$//')
  				for ipfix in $ip ; do
 					ipt I PREROUTING -t nat -s $AP1_net -d $ipfix -p tcp --dport 80 -j DNAT --to-destination "${DEFAULT}:80"
	 			done
			fi
		fi
  	done
}

clean() {
	[ -e "/var/run/blacklist.iptables" ] && sh /var/run/blacklist.iptables 2>/dev/null
	rm -f /var/run/blacklist.iptables 2>/dev/null
}

case $ACTION in
	"start"|"enable")
				clean
				[ -s "$BLACKLIST" ] || exit
				do_blacklist
				logger -st ${0##*/} "enabled"
				;; 

	"stop"|"disable") 
				clean 
				logger -st ${0##*/} "disabled"
				;;
esac
#
