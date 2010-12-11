#!/bin/sh
# RO.B.IN - 2007 by Antonio Anselmi <a.anselmi-at-oltrelinux-dot-com

IP_ap=$(uci get node.general.IP_mesh)
NODENAME=$(cat /proc/sys/kernel/hostname)
DEVICE_NAME=$(uci get node.general.board |tr A-Z a-z)
k_set=0
apversion=$(cat /etc/robin_version)
olsrversion=$(cat /etc/olsr_version)

enabled=$(uci get forwarder.general.enabled)

sp1=$(uci get forwarder.rule_1.IncomingPort)
dst1=$(uci get forwarder.rule_1.IPAddr)
dp1=$(uci get forwarder.rule_1.DstPort)

sp2=$(uci get forwarder.rule_2.IncomingPort)
dst2=$(uci get forwarder.rule_2.IPAddr)
dp2=$(uci get forwarder.rule_2.DstPort)

sp3=$(uci get forwarder.rule_3.IncomingPort)
dst3=$(uci get forwarder.rule_3.IPAddr)
dp3=$(uci get forwarder.rule_3.DstPort)

sp4=$(uci get forwarder.rule_4.IncomingPort)
dst4=$(uci get forwarder.rule_4.IPAddr)
dp4=$(uci get forwarder.rule_4.DstPort)

sp5=$(uci get forwarder.rule_5.IncomingPort)
dst5=$(uci get forwarder.rule_5.IPAddr)
dp5=$(uci get forwarder.rule_5.DstPort)

sp6=$(uci get forwarder.rule_6.IncomingPort)
dst6=$(uci get forwarder.rule_6.IPAddr)
dp6=$(uci get forwarder.rule_6.DstPort)

cat <<EOF_a
Content-Type: text/html
Pragma: no-cache

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xthml1/DTD/xhtml1-transitional.dtd">
<html>
<title>port forward: Robin-Mesh</title>
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

<form method=GET action="../cgi-bin/forwardSet.cgi">
<input type=hidden name=submit_type>
<table width=50% border=0>

<!--forwarder-->
EOF_a

cat <<EOF_01
<tr><td height="25" colspan=2>
<fieldset><legend>Port forwarding</legend>
<table border=0 width=100%>

<tr><td height="25">enabled&nbsp;
EOF_01
case $enabled in
	'1') 
	echo "<input name="enabled" type="radio" value="1" checked="checked">&nbsp;yes&nbsp;&nbsp;&nbsp;<input name="enabled" type="radio" value="0">&nbsp;no" 
	;;
	*) 
	echo "<input name="enabled" type="radio" value="1">&nbsp;yes&nbsp;&nbsp;&nbsp;<input name="enabled" type="radio" value="0" checked="checked">&nbsp;no"
	;;
esac

cat <<EOF_02
</td></tr>
<tr><td height="2"><hr size=1 no shade></td></tr>

<tr><td height="25">TCP port&nbsp;<input maxlength="5" size="5" name="sp1" value=$sp1>
	&nbsp;&nbsp;&nbsp;redirect to&nbsp;
	<input maxlength="15" size="15" name="dst1" value=$dst1>:<input maxlength="5" size="5" name="dp1" value=$dp1></td>
</tr>

<tr><td height="25">TCP port&nbsp;<input maxlength="5" size="5" name="sp2" value=$sp2>
	&nbsp;&nbsp;&nbsp;redirect to&nbsp;
	<input maxlength="15" size="15" name="dst2" value=$dst2>:<input maxlength="5" size="5" name="dp2" value=$dp2></td>
</tr>

<tr><td height="25">TCP port&nbsp;<input maxlength="5" size="5" name="sp3" value=$sp3>
	&nbsp;&nbsp;&nbsp;redirect to&nbsp;
	<input maxlength="15" size="15" name="dst3" value=$dst3>:<input maxlength="5" size="5" name="dp3" value=$dp3></td>
</tr>

<tr><td height="2"><hr size=1 no shade></td></tr>

<tr><td height="25">UDP port&nbsp;<input maxlength="5" size="5" name="sp4" value=$sp4>
	&nbsp;&nbsp;&nbsp;redirect to&nbsp;
	<input maxlength="15" size="15" name="dst4" value=$dst4>:<input maxlength="5" size="5" name="dp4" value=$dp4></td>
</tr>

<tr><td height="25">UDP port&nbsp;<input maxlength="5" size="5" name="sp5" value=$sp5>
	&nbsp;&nbsp;&nbsp;redirect to&nbsp;
	<input maxlength="15" size="15" name="dst5" value=$dst5>:<input maxlength="5" size="5" name="dp5" value=$dp5></td>
</tr>

<tr><td height="25">UDP port&nbsp;<input maxlength="5" size="5" name="sp6" value=$sp6>
	&nbsp;&nbsp;&nbsp;redirect to&nbsp;
	<input maxlength="15" size="15" name="dst6" value=$dst6>:<input maxlength="5" size="5" name="dp6" value=$dp6></td>
</tr>

</table>
EOF_02

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

