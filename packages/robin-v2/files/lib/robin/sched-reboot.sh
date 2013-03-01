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

# /lib/robin/sched-reboot.sh schedule a reboot

no_scheduled_reboot() {
	cat /tmp/crontab | crontab - 2>&-
	rm -f /tmp/crontab

	exit
}

is_never="never"
k_ok=0

command_string=$(uci get management.enable.force_reboot)
crontab -l |grep -v do_reboot > /tmp/crontab
[ "$command_string" == "$is_never" ] && no_scheduled_reboot
[ $(echo $command_string |grep '@') ] || exit 
hour=$(echo $command_string |awk -F @ '{print $2}')

if [ "$hour" -ge 0 -a "$hour" -le 23 ] ; then #repeate the check to prevent wrong manual entries
	freq=$(echo $command_string |awk -F @ '{print $1}')

	case $freq in
		'w')  
			k_ok=1
			echo  "0	$hour	*	*	0  /sbin/do_reboot 93" >> /tmp/crontab  ;; #weekly
		'm')  
			k_ok=1
			echo  "0	$hour 	1 	* 	*  /sbin/do_reboot 93" >> /tmp/crontab  ;; #monthly
		'12')
			if [ "$hour" -ge 0 -a "$hour" -le 11 ] ; then 
 				k_ok=1
				echo  "0	$hour,$hour2	*	*	*  /sbin/do_reboot 93" >> /tmp/crontab  #once every 12h 
			fi
			;;
		'24')
 			k_ok=1
			echo  "0	$hour	*	*	*  /sbin/do_reboot 93" >> /tmp/crontab  ;; #once every 24h
		'48')
			k_ok=1 
			echo  "0	$hour	*/2	*	*  /sbin/do_reboot 93" >> /tmp/crontab  ;; #once every 48h 
	esac
	[ 1 -eq "$k_ok" ] && cat /tmp/crontab | crontab - 2>&-
fi
rm -f /tmp/crontab
exit 
#
