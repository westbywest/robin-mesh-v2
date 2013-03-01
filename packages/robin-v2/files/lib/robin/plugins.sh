#!/bin/sh

run_plugins() {
	PLUGIN_DIR="/lib/robin/$1"
	PLUGIN_LIST="${PLUGIN_DIR}/plugin.list"

	if [ -s "$PLUGIN_LIST" ]; then
		pluginlist=$(grep -v '#' ${PLUGIN_LIST} |xargs)
		for PLUGIN in $pluginlist; do
			if [ -e "${PLUGIN_DIR}/${PLUGIN}" ]; then 
				sh ${PLUGIN_DIR}/${PLUGIN} 
			else
			logger -s -p "error" -t "could not run ${PLUGIN_DIR}/${PLUGIN}"
			fi
		done
	fi
}

source_plugins() {
	PLUGIN_DIR="/lib/robin/$1"
	PLUGIN_LIST="${PLUGIN_DIR}/plugin.list"

	if [ -s "$PLUGIN_LIST" ]; then
		pluginlist=$(grep -v '#' ${PLUGIN_LIST} |xargs)
		for PLUGIN in $pluginlist; do
			if [ -e "${PLUGIN_DIR}/${PLUGIN}" ]; then 
				. ${PLUGIN_DIR}/${PLUGIN} 
			else
			logger -s -p "error" -t "could not source ${PLUGIN_DIR}/${PLUGIN}"
			fi
		done
	fi
}
