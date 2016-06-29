#!/bin/bash
#
# @brief   NFS Server Manager
# @version ver.1.0
# @date    Mon Aug 24 16:22:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#  
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=$UTIL_ROOT/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/checkroot.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/checkcfg.sh
. $UTIL/bin/checkop.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

NFSMANAGER_TOOL=nfsmanager
NFSMANAGER_VERSION=ver.1.0
NFSMANAGER_HOME=$UTIL_ROOT/$NFSMANAGER_TOOL/$NFSMANAGER_VERSION
NFSMANAGER_CFG=$NFSMANAGER_HOME/conf/$NFSMANAGER_TOOL.cfg
NFSMANAGER_LOG=$NFSMANAGER_HOME/log

declare -A NFSMANAGER_USAGE=(
	[TOOL_NAME]="__$NFSMANAGER_TOOL"
	[ARG1]="[OPTION] start | stop | restart | list | version"
	[EX-PRE]="# Restart Apache Tomcat Server"
	[EX]="__$NFSMANAGER_TOOL restart"
)

declare -A LOG=(
	[TOOL]="$NFSMANAGER_TOOL"
	[FLAG]="info"
	[PATH]="$NFSMANAGER_LOG"
	[MSG]=""
)

TOOL_DBG="false"

SYSTEMCTL="/usr/bin/systemctl"
SHOWMOUNT="/usr/sbin/showmount"
NFSSTAT="/usr/sbin/nfsstat"
NFS_OP_LIST=( start stop restart list version )

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
	local MSG=""
	__checktool "$SHOWMOUNT"
	local STATUS=$?
	if [ "$STATUS" -eq "$SUCCESS" ]; then
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="List NFS disks"
			printf "$DEND" "$NFSMANAGER_TOOL" "$FUNC" "$MSG"
		fi
		eval "$SHOWMOUNT -a"
		return $SUCCESS
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
	local MSG=""
	__checktool "$NFSSTAT"
	local STATUS=$?
	if [ "$STATUS" -eq "$SUCCESS" ]; then
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Version of NFS server"
			printf "$DEND" "$NFSMANAGER_TOOL" "$FUNC" "$MSG"
		fi
		eval "$NFSSTAT –s"
		return $SUCCESS
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
		local MSG=""
		__checktool "$SYSTEMCTL"
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
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
		    eval "$SYSTEMCTL $OPERATION nfs.service"
		    return $SUCCESS
		fi
		return $NOT_SUCCESS
    fi 
    return $NOT_SUCCESS
}

#
# @brief Main function 
# @param Value required operation to be done
# @exitval Function __nfsmanger exit with integer value
#			0   - success operation 
#			128 - missing argument
#			129 - wrong argument
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
		local MSG=""
        __checkop "$OPERATION" "${NFS_OP_LIST[*]}"
        local STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
            __nfsoperation $OPERATION
            if [ "$TOOL_DBG" == "true" ]; then
            	printf "$DEND" "$NFSMANAGER_TOOL" "$FUNC" "Done"
            fi
            exit 0
        fi
        exit 129
    fi 
	__usage $NFSMANAGER_USAGE
    exit 128
}

#
# @brief   Main entry point
# @param   Value required operation to be done
# @exitval Script tool nfsmanger exit with integer value
#			0   - success operation 
# 			127 - run as root user
#			128 - missing argument
#			129 - wrong argument
#
printf "\n%s\n%s\n\n" "$NFSMANAGER_TOOL $NFSMANAGER_VERSION" "`date`"
__checkroot
STATUS=$?
if [ "$STATUS" -eq "$SUCCESS" ]; then
	set -u
	OPERATION=${1:-}
	__nfsmanager "$OPERATION"
fi

exit 127
