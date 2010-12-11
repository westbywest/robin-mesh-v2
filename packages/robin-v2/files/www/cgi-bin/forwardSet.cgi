#!/bin/sh
# RO.B.IN - 2007 by Antonio Anselmi <a.anselmi-at-oltrelinux-dot-com
# Revamp to code-base by Cody Cooper <cody-at-codycooper-dot-co-dot-nz>

IP_ap=$(uci get node.general.IP_mesh)
NODENAME=$(cat /proc/sys/kernel/hostname)
apversion=$(cat /etc/robin_version)
olsrversion=$(cat /etc/olsr_version)

cat <<EOF_1
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

<tr><td colspan=2><div class =textarea>&nbsp;APPLYING CHANGES FOR NODE ${IP_ap}</div></td></tr>
<tr><td colspan=2 valign =top><font color=#3cb83f>
<pre>
EOF_1

get_parameter() {
  echo "$query" | tr '&' '\n' | grep "^$1=" | head -1 | sed "s/.*=//" 
}

# discover request method
if [ "$REQUEST_METHOD" = POST ]; then
  query=$(head --bytes="$CONTENT_LENGTH")
  else
  query="$QUERY_STRING"
fi

### forwarder settings -----------------------------------------------#
enabled=$(get_parameter enabled)
[ -n "$enabled" ] && uci set forwarder.general.enabled="$enabled"

sp1=$(get_parameter sp1)
dst1=$(get_parameter dst1)
dp1=$(get_parameter dp1)
uci set forwarder.rule_1.IncomingPort="$sp1"
uci set forwarder.rule_1.IPAddr="$dst1"
uci set forwarder.rule_1.DstPort="$dp1"

sp2=$(get_parameter sp2)
dst2=$(get_parameter dst2)
dp2=$(get_parameter dp2)
uci set forwarder.rule_2.IncomingPort="$sp2"
uci set forwarder.rule_2.IPAddr="$dst2"
uci set forwarder.rule_2.DstPort="$dp2"

sp3=$(get_parameter sp3)
dst3=$(get_parameter dst3)
dp3=$(get_parameter dp3)
uci set forwarder.rule_3.IncomingPort="$sp3"
uci set forwarder.rule_3.IPAddr="$dst3"
uci set forwarder.rule_3.DstPort="$dp3"

sp4=$(get_parameter sp4)
dst4=$(get_parameter dst4)
dp4=$(get_parameter dp4)
uci set forwarder.rule_4.IncomingPort="$sp4"
uci set forwarder.rule_4.IPAddr="$dst4"
uci set forwarder.rule_4.DstPor="$dp4"

sp5=$(get_parameter sp5)
dst5=$(get_parameter dst5)
dp5=$(get_parameter dp5)
uci set forwarder.rule_5.IncomingPort="$sp5"
uci set forwarder.rule_5.IPAddr="$dst5"
uci set forwarder.rule_5.DstPort="$dp5"

sp6=$(get_parameter sp6)
dst6=$(get_parameter dst6)
dp6=$(get_parameter dp6)
uci set forwarder.rule_6.IncomingPort="$sp6"
uci set forwarder.rule_6.IPAddr="$dst6"
uci set forwarder.rule_6.DstPort="$dp6"

uci commit forwarder

echo ""
echo "done, you have to reboot the node."

cat <<EOF_99
</pre>
</td></tr>
</table>
</div>
</body>
</html>
EOF_99
