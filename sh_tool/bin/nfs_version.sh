#!/bin/bash
#
# @brief   NFS Manager
# @version ver.2.0
# @date    Sun 28 Nov 2021 09:09:28 AM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#

#
# @brief  Get version of nfs server
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nfs_version
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function __nfs_version {
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS
    MSG="Version of NFS server"
    info_debug_message "$MSG" "$FUNC" "$NFS_MANAGER_TOOL"
    local NFSTAT=${config_nfs_manager_util[NFSSTAT]}
    check_tool "${NFSTAT}"
    STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
        eval "${NFSTAT} –s"
        info_debug_message_end "Done" "$FUNC" "$NFS_MANAGER_TOOL"
        return $SUCCESS
    fi
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$NFS_MANAGER_TOOL"
    return $NOT_SUCCESS
}

