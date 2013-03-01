#!/bin/sh

[ "$(cat /etc/boots.log |wc -l)" -gt 200 ] && {
	tail -20 /etc/boots.log > /tmp/a
	cp -f /tmp/a /etc/boots.log
}

echo "> boot" >> /etc/boots.log
