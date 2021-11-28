#!/bin/bash
#
# @brief   NFS Manager
# @version ver.2.0
# @date    Sun 28 Nov 2021 09:09:28 AM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#

#
# @brief  List nfs mounted disks
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nfs_list
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
function __nfs_list {
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS
    local SHMNT=${config_nfs_manager_util[SHOWMOUNT]}
    check_tool "${SHMNT}"
    STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
        MSG="List NFS disks"
        info_debug_message "$MSG" "$FUNC" "$NFS_MANAGER_TOOL"
        eval "${SHMNT} -a"
        info_debug_message_end "Done" "$FUNC" "$NFS_MANAGER_TOOL"
        return $SUCCESS
    fi
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$NFS_MANAGER_TOOL"
    return $NOT_SUCCESS
}

