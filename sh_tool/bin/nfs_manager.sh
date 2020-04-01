#!/bin/bash
#
# @brief   NFS Server Manager (wrapper)
# @version ver.1.0.0
# @date    Mon Aug 24 16:22:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=${UTIL_ROOT}/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_root.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/check_op.sh
.    ${UTIL}/bin/logging.sh
.    ${UTIL}/bin/load_conf.sh
.    ${UTIL}/bin/load_util_conf.sh
.    ${UTIL}/bin/progress_bar.sh

NFS_MANAGER_TOOL=nfs_manager
NFS_MANAGER_VERSION=ver.1.0
NFS_MANAGER_HOME=${UTIL_ROOT}/${NFS_MANAGER_TOOL}/${NFS_MANAGER_VERSION}
NFS_MANAGER_CFG=${NFS_MANAGER_HOME}/conf/${NFS_MANAGER_TOOL}.cfg
NFS_MANAGER_UTIL_CFG=${NFS_MANAGER_HOME}/conf/${NFS_MANAGER_TOOL}_util.cfg
NFS_MANAGER_LOG=${NFS_MANAGER_HOME}/log

.    ${NFS_MANAGER_HOME}/bin/nfs_operation.sh

declare -A NFS_MANAGER_USAGE=(
    [USAGE_TOOL]="${NFS_MANAGER_TOOL}"
    [USAGE_ARG1]="[OPTION] start | stop | restart | list | version"
    [USAGE_EX_PRE]="# Restart Apache Tomcat Server"
    [USAGE_EX]="${NFS_MANAGER_TOOL} restart"
)

declare -A NFS_MANAGER_LOGGING=(
    [LOG_TOOL]="${NFS_MANAGER_TOOL}"
    [LOG_FLAG]="info"
    [LOG_PATH]="${NFS_MANAGER_LOG}"
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
#            0   - tool finished with success operation
#            128 - missing argument(s) from cli
#            129 - failed to load tool script configuration from files
#            130 - wrong operation to be done
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local OP="start"
# __nfsmanager $OP
#
function __nfsmanager {
    local OP=$1
    if [ -n "${OP}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        local STATUS_CONF STATUS_CONF_UTIL STATUS
        MSG="Loading basic and util configuration!"
        info_debug_message "$MSG" "$FUNC" "$NFS_MANAGER_TOOL"
        progress_bar PB_STRUCTURE
        declare -A config_nfs_manager=()
        load_conf "$NFS_MANAGER_CFG" config_nfs_manager
        STATUS_CONF=$?
        declare -A config_nfs_manager_util=()
        load_util_conf "$NFS_MANAGER_UTIL_CFG" config_nfs_manager_util
        STATUS_CONF_UTIL=$?
        declare -A STATUS_STRUCTURE=([1]=$STATUS_CONF [2]=$STATUS_CONF_UTIL)
        check_status STATUS_STRUCTURE
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$NFS_MANAGER_TOOL"
            exit 129
        fi
        TOOL_DBG=${config_nfs_manager[DEBUGGING]}
        TOOL_LOG=${config_nfs_manager[LOGGING]}
        TOOL_NOTIFY=${config_nfs_manager[EMAILING]}
        local OPERATIONS=${config_nfs_manager_util[NFS_OPERATIONS]}
        IFS=' ' read -ra OPS <<< "${OPERATIONS}"
        check_op "$OP" "${OPS[*]}"
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            __nfs_operation $OP
            MSG="Operation: ${OP} done"
            NFS_MANAGER_LOGGING[LOG_MSGE]=$MSG
            NFS_MANAGER_LOGGING[LOG_FLAG]="info"
            logging NFS_MANAGER_LOGGING
            info_debug_message_end "Done" "$FUNC" "$NFS_MANAGER_TOOL"
            exit 0
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$NFS_MANAGER_TOOL"
        exit 130
    fi
    usage NFS_MANAGER_USAGE
    exit 128
}

#
# @brief   Main entry point
# @param   Value required operation to be done
# @exitval Script tool nfsmanger exit with integer value
#            0   - tool finished with success operation
#            127 - run tool script as root user from cli
#            128 - missing argument(s) from cli
#            129 - failed to load tool script configuration from files
#            130 - wrong operation to be done
#
printf "\n%s\n%s\n\n" "${NFS_MANAGER_TOOL} ${NFS_MANAGER_VERSION}" "`date`"
check_root
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
    __nfsmanager $1
fi

exit 127

