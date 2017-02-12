#!/bin/bash
#
# @brief   Run operation on nfs service
# @version ver.1.0
# @date    Mon Aug 24 16:22:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

declare -A NFS_OPERATION_USAGE=(
	[USAGE_TOOL]="${NFSMANAGER_TOOL}"
	[USAGE_ARG1]="[OPTION] start | stop | restart | list | version"
	[USAGE_EX_PRE]="# Restart NFS Server"
	[USAGE_EX]="${NFSMANAGER_TOOL} restart"
)

.	${NFSMANAGER_HOME}/bin/nfs_version.sh
.	${NFSMANAGER_HOME}/bin/nfs_list.sh

#
# @brief  Run operation on nfs service
# @param  Value required operation to be done
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nfs_operation "$OP"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __nfs_operation() {
	local OP=$1
	if [ -n "${OP}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS
		MSG="nfs service [$OP]"
		__info_debug_message "$MSG" "$FUNC" "$NFSMANAGER_TOOL"
		local SYSCTL=${config_nfsmanager_util[SYSTEMCTL]}
		__check_tool "${SYSCTL}"
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			if [ "${OP}" == "list" ]; then
				__nfs_list
			elif [ "${OP}" == "version" ]; then
				__nfs_version
			else
				eval "${SYSCTL} ${OP} nfs.service"
			fi
			__info_debug_message_end "Done" "$FUNC" "$NFSMANAGER_TOOL"
			return $SUCCESS
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$NFSMANAGER_TOOL"
		return $NOT_SUCCESS
	fi
	__usage NFS_OPERATION_USAGE
	return $NOT_SUCCESS
}

