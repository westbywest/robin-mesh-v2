#!/bin/sh

awk -f /usr/lib/validate_config.awk -f - $* <<EOF
BEGIN {
	result=is_ip(ARGV[1])
	print result
}
EOF
