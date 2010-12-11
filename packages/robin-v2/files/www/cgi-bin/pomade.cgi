#!/bin/sh
# RO.B.IN - 2007 by Antonio Anselmi <a.anselmi-at-oltrelinux-dot-com

IP_ap=$(uci get node.general.IP_mesh)
NODENAME=$(cat /proc/sys/kernel/hostname)
DEVICE_NAME=$(uci get node.general.board |tr A-Z a-z)
k_set=0
apversion=$(cat /etc/robin_version)
olsrversion=$(cat /etc/olsr_version)

host=$(uci get pomade.server.host)
lan=$(uci get pomade.server.private_lan)
https=$(uci get pomade.server.https)
mode=$(uci get pomade.server.mode) 
cstm=$(uci get pomade.server.is_cstm_srv)

enabled=$(uci get pomade.client.enabled)
mycfg=$(uci get pomade.client.private_cfg)
ignore=$(uci get pomade.client.on_err_ignore)

cat <<EOF_a
Content-Type: text/html
Pragma: no-cache

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xthml1/DTD/xhtml1-transitional.dtd">
<html>
<title>the Poor Man Dashboard Environment: Robin-Mesh</title>
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

<form method=GET action="../cgi-bin/pomadeSet.cgi">
<input type=hidden name=submit_type>
<table width=70% border=0>

<!--Poor Man Dashboard Environment-->
EOF_a

cat <<EOF_01
<tr><td height="25" colspan=2>
<fieldset><legend>Poor Man Dashboard Environment Settings</legend>
<table border=0 width=100%>

<tr><td height="25" width=20%>enable this feature</td><td>
EOF_01
case $enabled in
	'1') 
	echo "<input name="enabled" type="radio" value="1" checked="checked">&nbsp;yes&nbsp;&nbsp;&nbsp;<input name="enabled" type="radio" value="0">&nbsp;no" 
	;;
	'0') 
	echo "<input name="enabled" type="radio" value="1">&nbsp;yes&nbsp;&nbsp;&nbsp;<input name="enabled" type="radio" value="0" checked="checked">&nbsp;no"
	;;
esac

cat <<ip
</td></tr>
<tr><td height="25" width=20%>host (IP or FQDN)</td>
<td align =left><input maxlength="40" size="30" name="host" value="$host">&nbsp;&nbsp;&nbsp;belong to LAN
ip
case $lan in
	'1') 
cat <<lany
&nbsp;<input name="lan" type="radio" value="1" checked="checked">&nbsp;yes
&nbsp;&nbsp;&nbsp;<input name="lan" type="radio" value="0">&nbsp;no 
lany
;;
	'0') 
cat <<lann
&nbsp;<input name="lan" type="radio" value="1">&nbsp;yes
&nbsp;&nbsp;&nbsp;<input name="lan" type="radio" value="0" checked="checked">&nbsp;no
lann
;;
esac
cat <<EOF_02
</td></tr>
<tr><td height="25" width=20%>use https</td><td>


EOF_02
case $https in
	1) 
cat <<EOF_02y
<input name="https" type="radio" value="1" checked="checked">&nbsp;yes
&nbsp;&nbsp;&nbsp;<input name="https" type="radio" value="0">&nbsp;no
EOF_02y
;;
	0) 
cat << EOF_02n
<input name="https" type="radio" value="1">&nbsp;yes
&nbsp;&nbsp;&nbsp;<input name="https" type="radio" value="0" checked="checked">&nbsp;no
EOF_02n
;;
esac

cat << EOF_03
</td></tr>
<tr><td height="25" width=20%>preferred mode</td><td>
EOF_03
case $mode in
	'php') 
cat << EOF_03php
<input name="mode" type="radio" value="php" checked="checked">&nbsp;php 
&nbsp;&nbsp;&nbsp;<input name="mode" type="radio" value="cfg">&nbsp;cfg 
EOF_03php
;;
	'cfg') 
cat << EOF_03cfg
<input name="mode" type="radio" value="php">&nbsp;php
&nbsp;&nbsp;&nbsp;<input name="mode" type="radio" value="cfg" checked="checked">&nbsp;cfg 
EOF_03cfg
;;
esac


cat << EOF_04
</td></tr>
<tr><td height="25" width=20%>act as custom.sh repo</td><td>
EOF_04
case $cstm in
	1) 
cat << si
<input name="cstm" type="radio" value="1" checked="checked">&nbsp;yes
&nbsp;&nbsp;&nbsp;<input name="cstm" type="radio" value="0">&nbsp;no
si
;;
	0) 
cat << no
<input name="cstm" type="radio" value="1">&nbsp;yes
&nbsp;&nbsp;&nbsp;<input name="cstm" type="radio" value="0" checked="checked">&nbsp;no
no
;;
esac

cat << EOF_05
</td></tr>
<tr><td height="25" width=20%>private configuration</td><td>
EOF_05

case $mycfg in
	1) 
echo "<input name="mycfg" type="radio" value="1" checked="checked">&nbsp;yes&nbsp;&nbsp;&nbsp;<input name="mycfg" type="radio" value="0">&nbsp;no" 

;;
	0) 
echo "<input name="mycfg" type="radio" value="1">&nbsp;yes&nbsp;&nbsp;&nbsp;<input name="mycfg" type="radio" value="0" checked="checked">&nbsp;no"
;;
esac

echo "</td></tr>"
echo "<tr><td height="25" width=20%>on err ignore 'reply'</td><td>"


case $ignore in
	1) 
cat << si
<input name="ignore" type="radio" value="1" checked="checked">&nbsp;yes
&nbsp;&nbsp;&nbsp;<input name="ignore" type="radio" value="0">&nbsp;no 
si
;;
	0) 
cat << no
<input name="ignore" type="radio" value="1">&nbsp;yes
&nbsp;&nbsp;&nbsp;<input name="ignore" type="radio" value="0" checked="checked">&nbsp;no
no
;;
esac

cat << EOF_99
</td></tr></table>
</fieldset>
</table>
</td>
</tr>
<tr><td colspan=2 align=right><input type= "submit" name="b1" value="SEND">&nbsp;<input type= "reset" name="b2" value="RESET"></td></tr>
</table>
</form>
</div>
</body>
</html>
EOF_99

