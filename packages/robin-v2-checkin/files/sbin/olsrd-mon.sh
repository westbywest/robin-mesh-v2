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

### available outputs other than /all
# "/neighbours" 
# "/neigh" 
# "/link" 
# "/route" 
# "/hna"
# "/mid" 
# "/topo"

clear
# CONFIGCHANGE
#echo "/all" | nc 127.0.0.1 8090
echo "/all" | nc 127.0.0.1 2006

#
