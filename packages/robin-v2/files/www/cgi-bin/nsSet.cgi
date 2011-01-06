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

<tr><td colspan=2><div class =textarea>&nbsp;APPLYING CHANGES FOR NODE ${IP_ap}</div></td></tr>
<tr><td colspan=2 valign =top><font color=black>
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

### name server settings -----------------------------------------------#
ns=$(get_parameter ns)
ns_curr=$(uci get management.enable.public)

if [ "$ns" == "$ns_curr" ]; then
	echo "name server settings unchanged"

	else
	if [ "$ns" -ge 0 -a "$ns" -le 5 ]; then
		echo "updating name server settings..."

		uci set management.enable.public_dns=$ns
		uci commit management
	
		echo "done."
		[ 0 -eq "$ns" -a "$(uci get node.general.role)" -eq 1 ] && {
			echo "You have to reboot this gateway."
		}

	else
		echo "value not allowed"
	fi
fi

cat <<EOF_99
</pre>
<br>
<a href="../cgi-bin/extras.cgi"><span><-- back</span></a>
</td></tr>
</table>
</div>
</body>
</html>
EOF_99
