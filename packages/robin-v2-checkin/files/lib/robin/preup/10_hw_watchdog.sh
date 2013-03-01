#!/bin/sh

signal_HWwatchdog() {
	/sbin/hw-heartbeat.sh
	(   
		echo "0-59/3	*	*	*	* /sbin/hw-heartbeat.sh"			
	) | crontab - 2>&- 
	sleep 1

	mkdir -p /var/spool/cron
	[ -L /var/spool/cron/crontabs ] || ln -s /etc/crontabs /var/spool/cron/crontabs
	crond -c /etc/crontabs
}

[ 1 -eq "$(uci get node.general.hw_watchdog)" ] && signal_HWwatchdog


