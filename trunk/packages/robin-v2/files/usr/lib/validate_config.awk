# AWK file for validating 
#
# Copyright (C) 2006 by Fokus Fraunhofer <carsten.tittel@fokus.fraunhofer.de>
# edited by Antonio Anselmi <tony.anselmi@gmail.com>

function is_channel(value) {
	valid = 1
	if  ( value > 0 && value < 12 ) { valid = 0 }
	return valid
}

function is_int(value) {
	valid = 0
	if (value !~ /^[0-9]*$/) { valid = 1 }
	return valid
}

function is_ip(value) {
	valid = 0
	if ((value != "") && (value !~ /^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$/)) valid = 1
	else {
		split(value, ipaddr, "\\.")
		for (i = 1; i <= 4; i++) {
			if ((ipaddr[i] < 0) || (ipaddr[i] > 255)) valid = 1
		}
	}
	return valid
}

function is_hostname(value) {
	valid = 0
	if (value !~ /^[0-9a-zA-z\.\-]*$/) {
		valid = 11
	}
	return valid;
}

function is_mac(value) {
	valid = 0
	if ((value != "") && (value !~ /^[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]$/)) {
		valid = 1
	}
	return valid
}


