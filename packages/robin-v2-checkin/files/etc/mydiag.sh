#!/bin/sh
#
# Copyright (C) 2009 OpenWrt.org
#
#

# TARGETCHANGE
#. /lib/ar71xx.sh

status_led=""

led_set_attr() {
# TARGETCHANGE
#	[ -f "/sys/class/leds/$1/$2" ] && echo "$3" > "/sys/class/leds/$1/$2"
	sleep 0 #no-op
}

status_led_set_timer() {
	led_set_attr $status_led "trigger" "timer"
	led_set_attr $status_led "delay_on" "$1"
	led_set_attr $status_led "delay_off" "$2"
}

set_led_on() {
	local x_led=$1
	led_set_attr $x_led "trigger" "none"
	led_set_attr $x_led "brightness" 255
}

set_led_off() {
	local x_led=$1
	led_set_attr $x_led "trigger" "none"
	led_set_attr $x_led "brightness" 0
}

status_led_on() {
	led_set_attr $status_led "trigger" "none"
	led_set_attr $status_led "brightness" 255
}

status_led_off() {
	led_set_attr $status_led "trigger" "none"
	led_set_attr $status_led "brightness" 0
}

get_status_led() {
# TARGETCHANGE
#	case $(ar71xx_board_name) in
	case foo in
	ap81)
		status_led="ap81:green:status"
		;;
	ap83)
		status_led="ap83:green:power"
		;;
	aw-nr580)
		status_led="aw-nr580:green:ready"
		;;
	bullet-m | rocket-m | nanostation-m)
		status_led="ubnt:green:link4"
		green_led="ubnt:green:link3"
		orange_led="ubnt:orange:link2"
		red_led="ubnt:red:link1"
		;;
	dir-600-a1)
		status_led="dir-600-a1:green:power"
		;;
	dir-615-c1)
		status_led="dir-615c1:green:status"
		;;
	dir-825-b1)
		status_led="dir825b1:orange:power"
		;;
	ls-sr71)
		status_led="ubnt:green:d22"
		;;
	mzk-w04nu)
		status_led="mzk-w04nu:green:status"
		;;
	mzk-w300nh)
		status_led="mzk-w300nh:green:status"
		;;
	pb44)
		status_led="pb44:amber:jump1"
		;;
	rb-411 | rb-411u | rb-433 | rb-433u | rb-450 | rb-450g | rb-493)
		status_led="rb4xx:yellow:user"
		;;
	routerstation | routerstation-pro)
		status_led="ubnt:green:rf"
		;;
	tew-632brp)
		status_led="tew-632brp:green:status"
		;;
	tl-wr1043nd)
		status_led="tl-wr1043nd:green:system"
		;;
	tl-wr741nd)
		status_led="tl-wr741nd:green:system"
		;;
	tl-wr841n-v1)
		status_led="tl-wr841n:green:system"
		;;
	tl-wr941nd)
		status_led="tl-wr941nd:green:system"
		;;
	wndr3700)
		status_led="wndr3700:green:power"
		;;
	wnr2000)
		status_led="wnr2000:green:power"
		;;
	wp543)
		status_led="wp543:green:diag"
		;;
	wrt400n)
		status_led="wrt400n:green:status"
		;;
	wrt160nl)
		status_led="wrt160nl:blue:wps"
		;;
	wzr-hp-g300nh)
		status_led="wzr-hp-g300nh:green:router"
		;;
	esac;
}
