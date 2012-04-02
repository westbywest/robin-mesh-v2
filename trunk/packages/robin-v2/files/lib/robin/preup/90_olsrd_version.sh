#!/bin/sh

olsrd -v > /tmp/pippo
olsr_version=$(cat /tmp/pippo |grep olsr.org -m1 |awk '{print $4}')
echo $olsr_version > /etc/olsr_version
