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

# /lib/robin/iwag-test.sh (I Was A GAteway test)

#http://robin.forumup.it/viewtopic.php?p=5740&highlight=bridge&mforum=robin#5740
#http://robin.forumup.it/viewtopic.php?p=5739&highlight=bridge&mforum=robin#5739

case $(uci get node.general.ethPorts) in
	2) iface=$(uci get node.general.wanPort) ;;
	1) iface="br-lan" ;;
esac

if udhcpc -t 4 -i $iface -n -q -s /usr/share/udhcpc/iwag.script ; then
	REASON=52 ; /sbin/do_reboot $REASON	
fi
#




