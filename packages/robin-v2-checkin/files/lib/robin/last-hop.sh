#!/bin/sh
# Robin-Mesh

fatal_error() {
	logger -st ${0##*/} "no last hop route available"
	echo "0 0 0 0" > /tmp/current_gateway

	return
}

parse_path() {
	hops=0
	routes=

	for hop_ip in $path
		do
		echo $hop_ip |grep -q '^5\.' && { LAST_HOP=$hop_ip; routes="${routes},${hop_ip}"; } || { true; return; }
		done

	 false
}

getLastHop() {
	f=0
# TOOLCHANGE
#	NEXT_HOP=$(ip route |grep default |awk '{print $3}')
	NEXT_HOP=$(route |grep -m 1 UGH |awk '{print $1}')
	[ -n $NEXT_HOP ] || fatal_error

	for i in $(seq 2 6)
		do
		path=$(traceroute -m$i -n 1.2.3.4 |awk '{print $2}' |xargs |sed s/'to'//g)
		parse_path && { f=1; break; }
		done

	if [ 1 -eq "$f" ]
		then 
		HOPS=$((i -1))
		rotte=$(echo $routes |sed s/^,//g)

		cost=$(olsrd-table.sh link |grep $NEXT_HOP |awk '{print $6}')
		TQ=$(echo $cost | awk '{printf("%2.0f\n", ((1/$1)*255)) }')

		echo "${LAST_HOP} ${TQ} ${HOPS} ${rotte}" > /tmp/current_gateway

		else
		fatal_error
		fi
}
#
