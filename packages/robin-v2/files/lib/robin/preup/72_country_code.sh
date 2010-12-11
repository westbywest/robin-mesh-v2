#!/bin/sh

COUNTRY_CODE=$(uci get management.enable.country_code)
[ -n "$COUNTRY_CODE" ] || COUNTRY_CODE="US"

uci set wireless.radio0.country=$COUNTRY_CODE
uci commit wireless
#
