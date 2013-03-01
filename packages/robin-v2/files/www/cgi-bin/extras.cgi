#!/bin/sh
# RO.B.IN - 2007 by Antonio Anselmi <a.anselmi-at-oltrelinux-dot-com
# Revamp to code-base by Cody Cooper <cody-at-codycooper-dot-co-dot-nz>

IP_ap=$(uci get node.general.IP_mesh)
NODENAME=$(cat /proc/sys/kernel/hostname)
apversion=$(cat /etc/robin_version)
olsrversion=$(cat /etc/olsr_version)

cat <<EOF_01
Content-Type: text/html
Pragma: no-cache

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xthml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>Extras: Robin-Mesh</title>
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

<tr>
<td colspan="2">

<fieldset>
<legend>Name Server</legend>
Allow to use one of the available public DNS or your ISP' DNS.<br />
<a href="../cgi-bin/ns.cgi">Go to Name Server Settings</a>
</fieldset>
<br>

<fieldset>
<legend>Gateway Static IP</legend>
Allows you to set a Static IP for the Gateway where this may be needed.<br /><br />
<a href="../cgi-bin/staticip.cgi">Go to Gateway Static IP Settings</a>
</fieldset>
<br>

<fieldset>
<legend>tune ACKtimeout</legend>
Allows you to set the best distance value to improve throughput.<br /><br />
<a href="../cgi-bin/distance.cgi">distance and ACKtimeout Settings</a>
</fieldset>
<br>

<fieldset>
<legend>Poor Man Dashboard Environment</legend>
Configure your remote server to act as simple dashboard for auto-provisioning.<br /><br />
<a href="../cgi-bin/pomade.cgi">Poor Man Dashboard Environment</a>
</fieldset>
<br>

<fieldset>
<legend>Port forwarding</legend>
Configure your remote server to act as simple dashboard for auto-provisioning.<br /><br />
<a href="../cgi-bin/forwarder.cgi">port forwarding settings</a>
</fieldset>

</td>
</tr>
</table>
</div>
</body>
</html>
EOF_01
