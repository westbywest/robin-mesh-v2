#!/bin/sh

NETWORK_CONFIG_PATH=/tmp/network
WIRELESS_CONFIG_PATH=/tmp/wireless

if [ 1 -eq "$ETH_PORTS" ]; then
	brctl show |grep br-lan && { 
		ifconfig br-lan down
		brctl delbr br-lan
	}
fi 

cp -f ${NETWORK_CONFIG_PATH} /etc/config/network 
cp -f ${WIRELESS_CONFIG_PATH} /etc/config/wireless 
