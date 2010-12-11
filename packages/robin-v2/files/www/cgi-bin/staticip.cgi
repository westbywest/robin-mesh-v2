#!/bin/sh
# RO.B.IN - 2007 by Antonio Anselmi <a.anselmi-at-oltrelinux-dot-com
# Revamp to code-base by Cody Cooper <cody-at-codycooper-dot-co-dot-nz>

IP_ap=$(uci get node.general.IP_mesh)
NODENAME=$(cat /proc/sys/kernel/hostname)
DEVICE_NAME=$(uci get node.general.board |tr A-Z a-z)
k_set=0
apversion=$(cat /etc/robin_version)
olsrversion=$(cat /etc/olsr_version)
node_role=$(uci get node.general.role)

[ -s /etc/dev_name ] && {
	DEV_NAME=$(cat /etc/dev_name)
	k_set=1
}

cat <<EOF_a
Content-Type: text/html
Pragma: no-cache

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xthml1/DTD/xhtml1-transitional.dtd">
<html>
<title>Gateway Static IP: robin-mesh</title>
<head>
<link rel="stylesheet" type="text/css" href="../resources/common.css">
</head>
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

<form method=GET action="../cgi-bin/staticipSet.cgi">
<input type=hidden name=submit_type />

<table width=70% border=0>
EOF_a

staticip=$(uci get installation.gw.ipaddr)
subnet=$(uci get installation.gw.netmask)
gateway=$(uci get installation.gw.defroute)

case $node_role in
'1')
cat <<EOF_gateway
<tr>
	<td height="25" colspan=2>
		<fieldset>
			<legend>Static IP settings</legend>
			<b>Please note:</b>
			<ul>
			<li>Changing these settings will result in a reboot of the Gateway</li>
			<li>These settings will <i>NOT</i> be checked prior to being saved!</li>
			</ul>
			
			<table>
			<tr>
			<td>Static IP</td>
			<td><input type="text" name="ip" value="$staticip"></td>
			</tr>
			<tr>
			<td>Subnet Mask</td>
			<td><input type="text" name="subnet" value="$subnet"></td>
			</tr>
			<tr>
			<td>Internet Gateway</td>
			<td><input type="text" name="gateway" value="$gateway"></td>
			</tr>
EOF_gateway
;;

*)
cat <<EOF_no
<tr>
	<td height="25" colspan=2>
		<fieldset><legend>Static IP Settings</legend>
			<table border=0 width=100% height=300>
				<tr>
					<td height="25" colspan=2 valign=top>
						<INPUT type=hidden name="devname" value="no">
						You can only set a Static IP address for a Gateway.
						<br />
						You are currently connected to a Repeater.
					</td>
				</tr>
EOF_no
;;
esac

cat <<EOF_99
</fieldset>
</table>
</td>
</tr>

<tr><td colspan=2 align=right><input type= "submit" name="b1" value="SEND">&nbsp;<input type= "reset" name="b2" value="RESET"></td></tr>
</table>
</form>

</table>
</div>
</body>
</html>
EOF_99
