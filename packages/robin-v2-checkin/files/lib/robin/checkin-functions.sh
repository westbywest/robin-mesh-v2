#!/bin/sh

ME=update
updt_host=$(uci get general.services.updt_srv)
checker=$(uci get general.services.checker)
node_role=$(uci get node.general.role)
KERNEL=$(uci get node.general.kernel)
BOARD=$(uci get node.general.board)
cp_HANDLER=$(uci get cp_switch.main.which_handler)

WDIR=/etc/update
DASHBOARD="${updt_host}/${checker}"
DASHBOARD_REPLY=$WDIR/received
OLD_REPLY=$WDIR/received.old
PMDE_REPLY=$WDIR/pomade.cfg

lastCheckin=$WDIR/last_checkin
key_config="#@#config"

curl_opt="--retry 1 --connect-timeout 40 -s -L -# -v"
curl_opt_ssl="${curl_opt} --insecure"

REASON=91	

skip() { return; }

do_checkin() {
	STATUS_FILE=/var/run/status_file
	cp $STATUS_FILE $WDIR/update.arg

	if [ 1 -eq "$(uci get management.enable.https)" ]; then
		case $(uci get management.enable.method_POST) in
			0) curl $curl_opt_ssl -G --data-ascii @$WDIR/update.arg "https://${DASHBOARD}" -o $DASHBOARD_REPLY ;;
			1) curl $curl_opt_ssl --data-ascii @$WDIR/update.arg "https://${DASHBOARD}" -o $DASHBOARD_REPLY ;;
		esac
		curl_result=$?

		else

		case $(uci get management.enable.method_POST) in
			0) curl $curl_opt -G --data-ascii @$WDIR/update.arg "http://${DASHBOARD}" -o $DASHBOARD_REPLY ;;
			1) curl $curl_opt --data-ascii @$WDIR/update.arg "http://${DASHBOARD}" -o $DASHBOARD_REPLY ;;
		esac
		curl_result=$?
	fi
}

do_checkin_pomade() {
	PMDE_SERVER=$(uci get pomade.server.host)
	PMDE_MODE=$(uci get pomade.server.mode)

   NETWORK=$(uci get node.general.net |tr a-z A-Z |sed s/*/_/g) 	
	PATH_TO_CFG="pomade/${NETWORK}"

	[ 1 -eq $(uci get pomade.client.private_cfg) ] && {
		MAC_ADDRESS=$(uci get node.general.myMAC |tr a-z A-Z |sed s/://g)
		PATH_TO_CFG="${PATH_TO_CFG}/${MAC_ADDRESS}"		
	}

	case $(uci get pomade.server.https) in
		'1') CURL=$curl_opt_ssl ; HTTP="https" ;;
		'0') CURL=$curl_opt ; HTTP="http" ;;
	esac

	for attempt in $(seq 1 3); do
		curl $CURL "${HTTP}://${PMDE_SERVER}/${PATH_TO_CFG}/pomade.${PMDE_MODE}" -O $PMDE_REPLY
		[ "$?" -eq 0 ] && return 0
	done
	return 1
}

blank_flags () {
	for FLAG in cps node system ; do
		uci set flags.restart.${FLAG}="0"
	done
	uci commit flags
}

heartbeat () {
	run_heartbeat=$(uci get cp_switch."handler_${cp_HANDLER}".need_heart )
		
	if [ "$run_heartbeat" -eq 1 ] ; then
		echo "sending heartbeat..."
		HEARTBEAT_SCRIPT=$(uci get cp_switch."handler_${cp_HANDLER}".heartbeat) 
		/sbin/${HEARTBEAT_SCRIPT}
	fi
}

checkin_dashboard () {
	echo "check dashboard..."
	
	do_checkin
	if [ "$curl_result" -ne 0 ]; then
		FALLBACK_IP=$(cat /etc/dashboard.fallback_ip)
		logger -st ${0##*/} "failed checking the dashboard, try dashboard fallback IP $FALLBACK_IP"
		DASHBOARD="${FALLBACK_IP}/${checker}"

		do_checkin
		[ "$curl_result" -ne 0 ] && {
			logger -st ${0##*/} "failed checking the dashboard, exit."
			exit
		}		
	fi

	chck_cnt=$(cat $lastCheckin |awk '{print $1}')
	let chck_cnt=chck_cnt+1 
	echo "$chck_cnt on $(date)" |sed s/GMT//g > $lastCheckin
	logger -st ${0##*/} "dashboard updated successfully: checkin #${chck_cnt}"
}

checkin_pomade() {
	ON_ERR_IGNORE=$(uci get pomade.client.on_err_ignore)
	echo "check pomade..."
	
	if $(do_checkin_pomade)
		then
		cp -f "$PMDE_REPLY" "$DASHBOARD_REPLY"
		pmde_message="pomade-provisioning successfully "

		else
		pmde_message="could not question pomade:"
		if [ "$ON_ERR_IGNORE" -eq 1 ]
			then
			rm -f $DASHBOARD_REPLY 
			pmde_message="${pmde_message} ignore reply"

			else
			pmde_message="${pmde_message} use reply"
		fi
	fi

	logger -st ${0##*/} $pmde_message
}

custom_update () {
     [ "$(uci get management.enable.custom_update)" -eq 1 ] || return	
	custom_host=$(uci get general.services.cstm_srv)

	if [ 1 -eq "$(uci get pomade.client.enabled)" -a \
		  1 -eq "$(uci get pomade.server.is_cstm_srv)" ]; then
		custom_host="${PMDE_SERVER}/${PATH_TO_CFG}/"
	fi

	WDIR=/etc/update
	CUSTOM_MD5=$WDIR/custom.md5
	[ -e $CUSTOM_MD5 ] || echo "$(md5sum /etc/robin_version | head -c 32)" > $CUSTOM_MD5	
	
	curl -L -# -v "http://${custom_host}custom.sh" -o /tmp/custom.sh
	if [ "$?" -ne 0 ] ; then
		logger -s -t  "$ME" "custom download failed!"
		return 
	fi
	
	PREV_CUSTOM_MD5=$(cat $CUSTOM_MD5)
	CURR_CUSTOM_MD5="$(md5sum /tmp/custom.sh | head -c 32)"
	
	if [ "$CURR_CUSTOM_MD5" = "$PREV_CUSTOM_MD5" ] ; then
		logger -s -t  "$ME" "nothing customized for this node"
		
		else # apply custom update
		echo $CURR_CUSTOM_MD5 > $CUSTOM_MD5
		chmod 755 /tmp/custom.sh
               $(sh /tmp/custom.sh)
               if [ "$?" -ne 0 ] ; then

                       # some part of custom.sh failed, remove the md5
                       $(rm -f $CUSTOM_MD5)
               fi
		wait
		rm -f /tmp/custom.sh
	fi
	return 
}

pre_process_reply () {
	local REPLY=$1

	while read record ; do
		[ -n "$record" ] && {
			field_1=$(echo $record |awk '{print $1}')

			case $field_1 in
				$key_config) 
					field_2=$(echo $record |awk '{print $2}') 
					file_out="${WDIR}/${field_2}"
					rm -f $file_out
					;;

				#hacking nodosgsplash
				"DownloadLimit"|"UploadLimit") skip ;;
				"TrafficControl") echo "TrafficControl 0" >> $file_out ;;

				$bogus) skip ;; 
				*) echo $record >> $file_out ;;
			esac
		}
	done < $REPLY

	[ -e $WDIR/ath_hal ] && mv $WDIR/ath_hal $WDIR/madwifi 

	[ -e $WDIR/splash-HTML ] && {
		splash_page_id=$(cat $REPLY |grep 'bogus2' |awk '{print $2}')
		[ -n "$splash_page_id" ] && echo "page_id $splash_page_id" >> $WDIR/splash-HTML
	}

	#alternate update server
	k_sec=$(cat $REPLY | awk '$1=="backend.update" {print $2}') 
	k_sec=${k_sec:-0}
	if [ "$k_sec" -eq 1 ] ; then
		SECONDARY_srv=$(cat $REPLY | awk '$1=="backend.server" {print $2}')	
		if [ -n $SECONDARY_srv ] ; then
			SECONDARY_srv=$(echo $SECONDARY_srv |tr -d '\r')					
			uci set general.services.updt_srv=$SECONDARY_srv
			uci commit general															
		fi							
	fi
}

update_UCI () {
	MODE="1"

	[ -h /usr/sbin/update-wireless.sh ] || ln -sf /usr/sbin/update-wifi.sh /usr/sbin/update-wireless.sh 
	[ -h /usr/sbin/update-nodogsplash.sh ] || ln -sf /usr/sbin/update-nodog.sh /usr/sbin/update-nodogsplash.sh 
	[ -h $WDIR/nodogsplash ] || ln -sf $WDIR/nodog $WDIR/nodogsplash

	for UCI_FILE in $(grep -v '#' $WDIR/uci-files |xargs)
		do
# selective READONLY
#		[ -e $WDIR/$UCI_FILE ] && /usr/sbin/update-${UCI_FILE}.sh $MODE
		case $UCI_FILE in
			"nodes") [ -e $WDIR/$UCI_FILE ] && /usr/sbin/update-${UCI_FILE}.sh $MODE ;;
			*) [ -e $WDIR/$UCI_FILE ] && logger checkin triggers update-${UCI_FILE}.sh $MODE ;;
		esac
		done
}
#
