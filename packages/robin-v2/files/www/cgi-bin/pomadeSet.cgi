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

### the Poor Man Dashboard Environment settings -----------------------------------------------#
host=$(get_parameter host |sed s/'%2F'/'\/'/g)
[ -n "$host" ] && uci set pomade.server.host="$host"

lan=$(get_parameter lan)
[ -n "$lan" ] && uci set pomade.server.private_lan="$lan"

https=$(get_parameter https)
[ -n "$https" ] && uci set pomade.server.https="$https"

mode=$(get_parameter mode)
[ -n "$mode" ] && uci set pomade.server.mode="$mode"

cstm=$(get_parameter cstm)
[ -n "$cstm" ] && uci set pomade.server.is_cstm_srv="$cstm"

enabled=$(get_parameter enabled)
[ -n "$enabled" ] && uci set pomade.client.enabled="$enabled"

mycfg=$(get_parameter mycfg)
[ -n "$mycfg" ] && uci set pomade.client.private_cfg="$mycfg"

ignore=$(get_parameter ignore)
[ -n "$ignore" ] && uci set pomade.client.on_err_ignore="$ignore"

uci commit pomade

echo ""
echo "done!"

cat <<EOF_99
</pre>
</td></tr>
</table>
</div>
</body>
</html>
EOF_99
