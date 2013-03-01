#!/bin/sh
# RO.B.IN - 2007 by Antonio Anselmi <a.anselmi-at-oltrelinux-dot-com

IP_ap=$(uci get node.general.IP_mesh)
NODENAME=$(cat /proc/sys/kernel/hostname)
DEVICE_NAME=$(uci get node.general.board |tr A-Z a-z)
k_set=0
apversion=$(cat /etc/robin_version)
olsrversion=$(cat /etc/olsr_version)

DISTANCE=$(cat /proc/sys/dev/wifi0/distance)

cat <<EOF_a
Content-Type: text/html
Pragma: no-cache

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xthml1/DTD/xhtml1-transitional.dtd">
<html>
<title>ACKtimeout: Robin-Mesh</title>
<head>
<link rel="stylesheet" type="text/css" href="../resources/common.css">
</head>
<body>
<div align=left>
<table width=70% border=0>
<tr>
<td width=350><a href="http://www.robin-mesh.org/"><img src="../resources/logo.png" border=0></a></td>
<td align=left><font color=#3cb83f><b>$NODENAME</b><br><i>${IP_ap}</i><br />${apversion} / ${olsrversion}</font></td>
</tr>

<tr><td colspan=2>
<ul id="tabsF">
<li><a href="../cgi-bin/status.cgi"><span>Status</span></a></li>
<li><a href="../cgi-bin/interfaces.cgi"><span>Interfaces</span></a></li>
<li><a href="../cgi-bin/mesh.cgi"><span>Mesh</span></a></li>
<li><a href="../cgi-bin/processes.cgi"><span>Processes</span></a></li>
<li><a href="../cgi-bin/log.cgi"><span>Log Messages</span></a></li>
<li><a href="../cgi-bin/extras.cgi"><span>Extras</span></a></li>
</ul>
</td></tr>

<form method=GET action="../cgi-bin/distanceSet.cgi">
<input type=hidden name=submit_type>
<table width=70% border=0>

<!--DISTANCE SETTINGS-->
EOF_a

cat <<EOF_99
<tr><td height="25" colspan=2>
<fieldset><legend>distance and ACKtimeout Settings</legend>
<table border=0 width=100% height=220>
<tr><td height="25" colspan=2 valign=top>
<p align =justify>
by entering the distance between the radios the node will calculate the time of flight of the packets in microseconds, and then set the ACK timeout to a little more than a round-trip time as the CTS
timeout as well as the Slot time to the one-way time.<br> 
(These settings are available in /proc/sys/dev/wifiX as slottime, ctstimeout, and acktimeout)</p>
Currently Settings:&nbsp;&nbsp;<b>$DISTANCE</b> 
<br>
<br>
New Settings:&nbsp;&nbsp;<input maxlength="5" size="5" name="dist" value="$DISTANCE">mt
</td></tr>

</fieldset>
</table>
</td>
</tr>
<tr><td colspan=2 align=right><input type= "submit" name="b1" value="SEND">&nbsp;<input type= "reset" name="b2" value="RESET"></td></tr>
</table>
</form>

<!--end main table ###########################################################################-->

</div>
</body>
</html>
EOF_99
