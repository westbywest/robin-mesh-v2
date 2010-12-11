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
<title>Status: open-mesh</title>
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
<legend>Dashboard</legend>
EOF_01
lastCheckin=$(cat /etc/update/last_checkin)
echo "Check-in count: $lastCheckin"
cat <<EOF_02
</fieldset>
<br>
<fieldset>
<legend>Wireless Connectivity</legend>
<pre>
EOF_02
/sbin/get-rssi.sh > /tmp/page
cat /tmp/page
cat <<EOF_03
</pre>
</fieldset>
<br>
<fieldset>
<legend>Internet Speedtest</legend>
EOF_03
### network transfer rate
	node_role=$(uci get node.general.role)
	upgd_host=$(uci get general.services.upgd_srv)
	if [ "$node_role" -eq 0 ] ; then
		n_times="1"
		[ -e /tmp/current_ntr ] || /sbin/speed-test $n_times
		curr_GATEWAY_IP=$(cat /tmp/current_gateway |awk '{print $1}') 
		curr_GATEWAY_name=$(cat /etc/update/nodes |grep $curr_GATEWAY_IP |awk '{print $3}')
		ntr=$(cat /tmp/current_ntr) 
		rm -f /tmp/current_ntr
		echo -n "Using $curr_GATEWAY_IP ($curr_GATEWAY_name) as the current gateway.<br />Internet Throughput: $ntr"
	else	
		TEST_FILE="${upgd_host}speed-test"
		(
			wget -O  /tmp/dummy  "http://${TEST_FILE}"
		) > /tmp/ST_res 2>&1

		if [ "$(wget -V |grep Wget |awk '{print $3}')" == "1.10.2" ] ; then 
			ntr=$(cat /tmp/ST_res |tail -2 |grep dummy |awk '{print $2 "-" $3}' |sed "s/(//g" |sed "s/)//g")
		else # 1.11.4 (and major too?)
			ntr=$(cat /tmp/ST_res |tail -2 |grep dummy |awk '{print $3 "-" $4}' |sed "s/(//g" |sed "s/)//g")
		fi
		echo "This device is connected directly to the Internet.<br />Internet Throughput: $ntr"
	fi
cat <<EOF_99
</fieldset>
</td>
</tr>
</table>
</div>
</body>
</html>
EOF_99
