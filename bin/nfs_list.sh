#!/bin/bash
#
# @brief   List nfs mounted disks
# @version ver.1.0
# @date    Mon Aug 24 16:22:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

#
# @brief  List nfs mounted disks
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nfs_list
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
function __nfs_list() {
	local FUNC=${FUNCNAME[0]} MSG="None" STATUS
	local SHMNT=${config_nfsmanager_util[SHOWMOUNT]}
	__check_tool "${SHMNT}"
	STATUS=$?
	if [ $STATUS -eq $SUCCESS ]; then
		MSG="List NFS disks"
		__info_debug_message "$MSG" "$FUNC" "$NFSMANAGER_TOOL"
		eval "${SHMNT} -a"
		__info_debug_message_end "Done" "$FUNC" "$NFSMANAGER_TOOL"
		return $SUCCESS
	fi
	MSG="Force exit!"
	__info_debug_message_end "$MSG" "$FUNC" "$NFSMANAGER_TOOL"
	return $NOT_SUCCESS
}

