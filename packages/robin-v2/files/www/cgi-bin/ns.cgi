#!/bin/sh
# RO.B.IN - 2007 by Antonio Anselmi <a.anselmi-at-oltrelinux-dot-com

IP_ap=$(uci get node.general.IP_mesh)
NODENAME=$(cat /proc/sys/kernel/hostname)
DEVICE_NAME=$(uci get node.general.board |tr A-Z a-z)
k_set=0
apversion=$(cat /etc/robin_version)
olsrversion=$(cat /etc/olsr_version)

ns=$(uci get management.enable.public_dns)
case $ns in
	1) PUBLIC_DNS="opendns" ;;
	2) PUBLIC_DNS="familyshield" ;;
	3) PUBLIC_DNS="google" ;;
	4) PUBLIC_DNS="scrubit" ;;
	5) PUBLIC_DNS="dnsadvantage" ;;
	0) PUBLIC_DNS="ISP' DNS" ;;
esac

cat <<EOF_a
Content-Type: text/html
Pragma: no-cache

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xthml1/DTD/xhtml1-transitional.dtd">
<html>
<title>Name Server: Robin-Mesh</title>
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
<li><a href="../cgi-bin/config.cgi"><span>Configuration</span></a></li>
<li><a href="../cgi-bin/interfaces.cgi"><span>Interfaces</span></a></li>
<li><a href="../cgi-bin/mesh.cgi"><span>Mesh</span></a></li>
<li><a href="../cgi-bin/processes.cgi"><span>Processes</span></a></li>
<li><a href="../cgi-bin/log.cgi"><span>Log Messages</span></a></li>
<li><a href="../cgi-bin/extras.cgi"><span>Extras</span></a></li>
</ul>
</td></tr>

<form method=GET action="../cgi-bin/nsSet.cgi">
<input type=hidden name=submit_type>
<table width=70% border=0>

<!--DISTANCE SETTINGS-->
EOF_a

cat <<EOF_99
<tr><td height="25" colspan=2>
<fieldset><legend>Name Server Settings</legend>
<table border=0 width=100% height=220>
<tr><td height="25" colspan=2 valign=top>
<p align =justify>
<b>available values</b>
<ul>
<li>0: ISP' DNS <i>(in gateways only since repeaters will be redirected)</i>
<li>1: opendns
<li>2: familyshield
<li>3: google
<li>4: scrubit
<li>5: dnsadvantage
</ul>
</p>
Currently Settings:&nbsp;&nbsp;<b>$PUBLIC_DNS</b> 
<br>
<br>
New Settings:&nbsp;&nbsp;<input maxlength="1" size="5" name="ns" value="$ns">
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
