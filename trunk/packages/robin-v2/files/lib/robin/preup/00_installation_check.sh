#!/bin/sh 

MUST_BE_AUTO="-1"
ETH_PORTS=$(uci get node.general.ethPorts)

[ 1 -eq "$ETH_PORTS" ] && {
	uci set installation.node.predef_role=$MUST_BE_AUTO
	uci commit installation
}
