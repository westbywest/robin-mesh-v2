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

# if you need only messages headers:
# 	olsrd-dump.sh |grep -A 1 Hello 
#	olsrd-dump.sh |grep -A 1 TC
# 	olsrd-dump.sh |grep -A 1 HNA

FILE_DEST=$1
which tcpdump > /dev/null || { echo "you must first install tcpdump and libpcap"; exit 1; }
mesh_ifname=$(uci -P /var/state get mesh.iface.ifname)

OPTIONS="-s 0 -ni ${mesh_ifname} -v port 698"
[ -n "$FILE_DEST" ] && OPTIONS="${OPTIONS} -w /tmp/$FILE_DEST"

tcpdump $OPTIONS 
#

