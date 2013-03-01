#!/bin/sh

for FLAG in cps node system iwag ; do
	uci set flags.restart.${FLAG}="0"
done
uci set flags.status.RR="1"
uci commit flags
