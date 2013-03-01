robin-v2-checkin
================

This package will perform checkins to the Cloudtrax dashboard at https://cloudtrax.com or to Open Source clones like the Meshconnect dashboard.  At present, these checkins are read-only, i.e any configuration changes received from a dashboard in response to a checkin are ignored.  This code is NOT compatible with the proprietary NG dashboard features also offered by Cloudtrax.

This code was derived from the ROBIN Mesh Firmware http://wiki-robin.meshroot.com/ and from ROBIN v2 at http://subversion.assembla.com/svn/robin_v2

Modifications/derivations by Benjamin West / WasabiNet <ben@gowasabi.net> http://gowasabi.net

CAVEAT: This code is still under development.  The author makes no guarantee that it will not raid your kitchen of all food one night and kill a kitten.

Notes
=====

Legend for various tags added to code for the author's reference:

- READONLY marks changes to prevent node configuration changes by check-in script
- CONFIGCHANGE marks config changes that depart from robin convention
- TARGETCHANGE marks changes to make robin checkin target independent
- TOOLCHANGE makrs changes to prevent robin from overriding default OpenWRT tools/commands

License
=======
Copyright (C) 2010 Antonio Anselmi <tony.anselmi@gmail.com> and (C) 2013 Benjamin West <ben@gowasabi.net> .

This program is free software; you can redistribute it and/or modify it under the terms of version 2 of the GNU General Public License as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
