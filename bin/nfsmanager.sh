#!/bin/bash
#
# @brief   NFS Server Manager (wrapper)
# @version ver.1.0
# @date    Mon Aug 24 16:22:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=${UTIL_ROOT}/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/check_root.sh
.	${UTIL}/bin/check_tool.sh
.	${UTIL}/bin/check_op.sh
.	${UTIL}/bin/logging.sh
.	${UTIL}/bin/load_conf.sh
.	${UTIL}/bin/load_util_conf.sh
.	${UTIL}/bin/progress_bar.sh

NFSMANAGER_TOOL=nfsmanager
NFSMANAGER_VERSION=ver.1.0
NFSMANAGER_HOME=${UTIL_ROOT}/${NFSMANAGER_TOOL}/${NFSMANAGER_VERSION}
NFSMANAGER_CFG=${NFSMANAGER_HOME}/conf/${NFSMANAGER_TOOL}.cfg
NFSMANAGER_UTIL_CFG=${NFSMANAGER_HOME}/conf/${NFSMANAGER_TOOL}_util.cfg
NFSMANAGER_LOG=${NFSMANAGER_HOME}/log

.	${NFSMANAGER_HOME}/bin/nfs_operation.sh

declare -A NFSMANAGER_USAGE=(
	[USAGE_TOOL]="${NFSMANAGER_TOOL}"
	[USAGE_ARG1]="[OPTION] start | stop | restart | list | version"
	[USAGE_EX_PRE]="# Restart Apache Tomcat Server"
	[USAGE_EX]="${NFSMANAGER_TOOL} restart"
)

declare -A NFSMANAGER_LOGGING=(
	[LOG_TOOL]="${NFSMANAGER_TOOL}"
	[LOG_FLAG]="info"
	[LOG_PATH]="${NFSMANAGER_LOG}"
	[LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
	[BW]=50
	[MP]=100
	[SLEEP]=0.01
)

TOOL_DBG="false"
TOOL_LOG="false"
TOOL_NOTIFY="false"

#
# @brief Main function
# @param Value required operation to be done
# @exitval Function __nfsmanger exit with integer value
#			0   - tool finished with success operation
#			128 - missing argument(s) from cli
#			129 - failed to load tool script configuration from files
#			130 - wrong operation to be done
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local OP="start"
# __nfsmanager $OP
#
function __nfsmanager() {
	local OP=$1
	if [ -n "${OP}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS_CONF STATUS_CONF_UTIL STATUS
		MSG="Loading basic and util configuration!"
		__info_debug_message "$MSG" "$FUNC" "$NFSMANAGER_TOOL"
		__progress_bar PB_STRUCTURE
		declare -A config_nfsmanager=()
		__load_conf "$NFSMANAGER_CFG" config_nfsmanager
		STATUS_CONF=$?
		declare -A config_nfsmanager_util=()
		__load_util_conf "$NFSMANAGER_UTIL_CFG" config_nfsmanager_util
		STATUS_CONF_UTIL=$?
		declare -A STATUS_STRUCTURE=([1]=$STATUS_CONF [2]=$STATUS_CONF_UTIL)
		__check_status STATUS_STRUCTURE
		STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$NFSMANAGER_TOOL"
			exit 129
		fi
		TOOL_DBG=${config_nfsmanager[DEBUGGING]}
		TOOL_LOG=${config_nfsmanager[LOGGING]}
		TOOL_NOTIFY=${config_nfsmanager[EMAILING]}
		local OPERATIONS=${config_nfsmanager_util[NFS_OPERATIONS]}
		IFS=' ' read -ra OPS <<< "${OPERATIONS}"
		__check_op "$OP" "${OPS[*]}"
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			__nfs_operation $OP
			MSG="Operation: ${OP} done"
			NFSMANAGER_LOGGING[LOG_MSGE]=$MSG
			NFSMANAGER_LOGGING[LOG_FLAG]="info"
			__logging NFSMANAGER_LOGGING
			__info_debug_message_end "Done" "$FUNC" "$NFSMANAGER_TOOL"
			exit 0
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$NFSMANAGER_TOOL"
		exit 130
	fi
	__usage NFSMANAGER_USAGE
	exit 128
}

#
# @brief   Main entry point
# @param   Value required operation to be done
# @exitval Script tool nfsmanger exit with integer value
#			0   - tool finished with success operation
# 			127 - run tool script as root user from cli
#			128 - missing argument(s) from cli
#			129 - failed to load tool script configuration from files
#			130 - wrong operation to be done
#
printf "\n%s\n%s\n\n" "${NFSMANAGER_TOOL} ${NFSMANAGER_VERSION}" "`date`"
__check_root
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
	__nfsmanager $1
fi

exit 127

