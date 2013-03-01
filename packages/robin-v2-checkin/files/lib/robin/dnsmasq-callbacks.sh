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

# /lib/robin/dnsmasq-callbacks.sh
#
# This script is called each time dnsmasq issues an ip address, deletes an ip or
# is restarted (old).  This script parses /lib/robin/callbacks/*/*
# or /etc/callbacks.local/*/* and runs the .sh files in these
# it passes on the arguments that it rec'd from dnsmasq
#  

# add, old, del
ACTION=$1
                                                                                                                    
case $ACTION in
    'add'|'old') # If this is a new entry or an existing entry (i.e. already issued dhcp request).
        for callbacks_source_file in /lib/robin/callbacks/add-old/*; do
            . $callbacks_source_file $1 $2 $3 $4
        done

        for callbacks_source_file in /etc/callbacks.local/add-old/*; do
            sh $callbacks_source_file $1 $2 $3 $4
        done
    ;;

    'del') # If this DHCP entry is being deleted
        for callbacks_source_file in /lib/robin/callbacks/del/*; do
            . $callbacks_source_file $1 $2 $3 $4
        done

        for callbacks_source_file in /etc/callbacks.local/del/*; do
            sh $callbacks_source_file $1 $2 $3 $4
        done
    ;;
esac
#

