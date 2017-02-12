#!/bin/bash
#
# @brief   Get version of nfs server
# @version ver.1.0
# @date    Mon Aug 24 16:22:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

#
# @brief  Get version of nfs server
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nfs_version
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
function __nfs_version() {
	local FUNC=${FUNCNAME[0]} MSG="None" STATUS
	MSG="Version of NFS server"
	__info_debug_message "$MSG" "$FUNC" "$NFSMANAGER_TOOL"
	local NFSTAT=${config_nfsmanager_util[NFSSTAT]}
	__check_tool "${NFSTAT}"
	STATUS=$?
	if [ $STATUS -eq $SUCCESS ]; then
		eval "${NFSTAT} –s"
		__info_debug_message_end "Done" "$FUNC" "$NFSMANAGER_TOOL"
		return $SUCCESS
	fi
	MSG="Force exit!"
	__info_debug_message_end "$MSG" "$FUNC" "$NFSMANAGER_TOOL"
	return $NOT_SUCCESS
}

