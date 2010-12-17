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

# /usr/sbin/update-ethers.sh

CALLER=$1
CALLER="${CALLER:-1}"
WDIR=/etc/update

[ -s "$WDIR/ethers" ] || exit 1

if [ -s /etc/ethers ]; then
	SHOULD_REPLACE=0
	curr_ethers_md5=$(md5sum /etc/ethers |awk '{print $1}')
	rcvd_ethers_md5=$(md5sum $WDIR/ethers |awk '{print $1}')

	[ "$curr_ethers_md5" == "$rcvd_ethers_md5" ] && SHOULD_REPLACE=1 

	else
	SHOULD_REPLACE=1
fi

[ 1 -eq "$SHOULD_REPLACE" ] && {
	cp -s $WDIR/ethers /etc/ethers

	/etc/init.d/dhcpd stop
	sleep 1
	/etc/init.d/dhcpd start
}
#
