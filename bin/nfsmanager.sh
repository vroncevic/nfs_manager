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
UTIL=$UTIL_ROOT/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/checkroot.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/checkop.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/sendmail.sh
. $UTIL/bin/loadconf.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/progressbar.sh

NFSMANAGER_TOOL=nfsmanager
NFSMANAGER_VERSION=ver.1.0
NFSMANAGER_HOME=$UTIL_ROOT/$NFSMANAGER_TOOL/$NFSMANAGER_VERSION
NFSMANAGER_CFG=$NFSMANAGER_HOME/conf/$NFSMANAGER_TOOL.cfg
NFSMANAGER_UTIL_CFG=$NFSMANAGER_HOME/conf/${NFSMANAGER_TOOL}_util.cfg
NFSMANAGER_LOG=$NFSMANAGER_HOME/log

declare -A NFSMANAGER_USAGE=(
	[USAGE_TOOL]="__$NFSMANAGER_TOOL"
	[USAGE_ARG1]="[OPTION] start | stop | restart | list | version"
	[USAGE_EX_PRE]="# Restart Apache Tomcat Server"
	[USAGE_EX]="__$NFSMANAGER_TOOL restart"
)

declare -A NFSMANAGER_LOG=(
	[LOG_TOOL]="$NFSMANAGER_TOOL"
	[LOG_FLAG]="info"
	[LOG_PATH]="$NFSMANAGER_LOG"
	[LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
	[BAR_WIDTH]=50
	[MAX_PERCENT]=100
	[SLEEP]=0.01
)

TOOL_DBG="false"

#
# @brief  List nfs mounted disks
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nfslist
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
function __nfslist() {
	local FUNC=${FUNCNAME[0]}
	local MSG="None"
	__checktool "${confignfsmanagerutil[SHOWMOUNT]}"
	local STATUS=$?
	if [ $STATUS -eq $SUCCESS ]; then
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="List NFS disks"
			printf "$DEND" "$NFSMANAGER_TOOL" "$FUNC" "$MSG"
		fi
		eval "${confignfsmanagerutil[SHOWMOUNT]} -a"
		return $SUCCESS
	fi
	MSG="Missing external tool ${confignfsmanagerutil[SHOWMOUNT]}"
	if [ "${confignfsmanager[LOGGING]}" == "true" ]; then
		NFSMANAGER_LOGGING[LOG_MSGE]="$MSG"
		NFSMANAGER_LOGGING[LOG_FLAG]="error"
		__logging NFSMANAGER_LOGGING
	fi
	if [ "${confignfsmanager[EMAILING]}" == "true" ]; then
		__sendmail "$MSG" "${confignfsmanager[ADMIN_EMAIL]}"
	fi
    return $NOT_SUCCESS
}

#
# @brief  Get version of nfs server
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nfsversion
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
function __nfsversion() {
	local FUNC=${FUNCNAME[0]}
	local MSG="None"
	__checktool "${confignfsmanagerutil[NFSSTAT]}"
	local STATUS=$?
	if [ $STATUS -eq $SUCCESS ]; then
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Version of NFS server"
			printf "$DEND" "$NFSMANAGER_TOOL" "$FUNC" "$MSG"
		fi
		eval "${confignfsmanagerutil[NFSSTAT]} –s"
		return $SUCCESS
	fi
	MSG="Missing external tool ${confignfsmanagerutil[NFSSTAT]}"
	if [ "${confignfsmanager[LOGGING]}" == "true" ]; then
		NFSMANAGER_LOGGING[LOG_MSGE]="$MSG"
		NFSMANAGER_LOGGING[LOG_FLAG]="error"
		__logging NFSMANAGER_LOGGING
	fi
	if [ "${confignfsmanager[EMAILING]}" == "true" ]; then
		__sendmail "$MSG" "${confignfsmanager[ADMIN_EMAIL]}"
	fi
	return $NOT_SUCCESS
}

#
# @brief  Run operation on nfs service
# @param  Value required operation to be done
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nfsoperation "$OPERATION"
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
function __nfsoperation() {
    local OPERATION=$1
    if [ -n "$OPERATION" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		__checktool "${confignfsmanagerutil[SYSTEMCTL]}"
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			if [ "$OPERATION" == "list" ]; then
	        	__nfslist
				return $SUCCESS
		    fi
			if [ "$OPERATION" == "version" ]; then
				__nfsversion
				return $SUCCESS
			fi
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="nfs service [$OPERATION]"
            	printf "$DEND" "$NFSMANAGER_TOOL" "$FUNC" "$MSG"
            fi
		    eval "${confignfsmanagerutil[SYSTEMCTL]} $OPERATION nfs.service"
		    return $SUCCESS
		fi
		MSG="Missing external tool ${confignfsmanagerutil[SYSTEMCTL]}"
		if [ "${confignfsmanager[LOGGING]}" == "true" ]; then
			NFSMANAGER_LOGGING[LOG_MSGE]="$MSG"
			NFSMANAGER_LOGGING[LOG_FLAG]="error"
			__logging NFSMANAGER_LOGGING
		fi
		if [ "${confignfsmanager[EMAILING]}" == "true" ]; then
			__sendmail "$MSG" "${confignfsmanager[ADMIN_EMAIL]}"
		fi
		return $NOT_SUCCESS
    fi 
    return $NOT_SUCCESS
}

#
# @brief Main function 
# @param Value required operation to be done
# @exitval Function __nfsmanger exit with integer value
#			0   - tool finished with success operation 
#			128 - missing argument(s) from cli 
#			129 - failed to load tool script configuration from file 
#			130 - failed to load tool script utilities configuration from file
#			131 - wrong operation to be done
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local OPERATION="start"
# __nfsmanager $OPERATION
#
function __nfsmanager() {
    local OPERATION=$1
    if [ -n $OPERATION ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="Loading basic and util configuration"
		printf "$SEND" "$NFSMANAGER_TOOL" "$MSG"
		__progressbar PB_STRUCTURE
		printf "%s\n\n" ""
		declare -A confignfsmanager=()
		__loadconf $NFSMANAGER_CFG confignfsmanager
		local STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Failed to load tool script configuration"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$NFSMANAGER_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$NFSMANAGER_TOOL" "$MSG"
			fi
			exit 129
		fi
		declare -A confignfsmanagerutil=()
		__loadutilconf $NFSMANAGER_UTIL_CFG confignfsmanagerutil
		STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Failed to load tool script utilities configuration"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$NFSMANAGER_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$NFSMANAGER_TOOL" "$MSG"
			fi
			exit 130
		fi
		NFS_OP_LIST=( start stop restart list version )
        __checkop "$OPERATION" "${NFS_OP_LIST[*]}"
        local STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            __nfsoperation $OPERATION
			MSG="Operation: $OPERATION done"
			if [ "${confignfsmanager[LOGGING]}" == "true" ]; then
				NFSMANAGER_LOGGING[LOG_MSGE]="$MSG"
				NFSMANAGER_LOGGING[LOG_FLAG]="info"
				__logging NFSMANAGER_LOGGING
			fi
            if [ "$TOOL_DBG" == "true" ]; then
            	printf "$DEND" "$NFSMANAGER_TOOL" "$FUNC" "Done"
            fi
            exit 0
        fi
        exit 131
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
#			129 - failed to load tool script configuration from file 
#			130 - failed to load tool script utilities configuration from file
#			131 - wrong operation to be done
#
printf "\n%s\n%s\n\n" "$NFSMANAGER_TOOL $NFSMANAGER_VERSION" "`date`"
__checkroot
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
	__nfsmanager $1
fi

exit 127

