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

# /sbin/hw-heartbeat.sh
#  send heartbeat to the hardware watchdog 

GPO="3"
MCTL="4"

[ "$(uci get node.general.hw_watchdog)" -eq 1 ] && { 
	gpioctl dirout $GPO ; gpioctl clear $GPO
	sleep 1
	gpioctl set $GPO
	logger -st ${0##*/} "signaling to the hw-watchdog"
}
#


