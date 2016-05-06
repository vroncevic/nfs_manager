#!/bin/bash
#
# @brief   NFS Server Management
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
. $UTIL/bin/checkop.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

TOOL_NAME=nfsmanager
TOOL_VERSION=ver.1.0
TOOL_HOME=$UTIL_ROOT/$TOOL_NAME/$TOOL_VERSION
TOOL_CFG=$TOOL_HOME/conf/$TOOL_NAME.cfg
TOOL_LOG=$TOOL_HOME/log

declare -A NFSMANAGER_USAGE=(
	[TOOL_NAME]="__$TOOL_NAME"
	[ARG1]="[OPTION] start | stop | restart | list | version"
	[EX-PRE]="# Restart Apache Tomcat Server"
	[EX]="__$TOOL_NAME restart"	
)

declare -A LOG=(
	[TOOL]="$TOOL_NAME"
	[FLAG]="info"
	[PATH]="$TOOL_LOG"
	[MSG]=""
)

TOOL_DEBUG="false"

SYSTEMCTL="/usr/bin/systemctl"
SHOWMOUNT="/usr/sbin/showmount"
NFSSTAT="/usr/sbin/nfsstat"
NFS_OP_LIST=( start stop restart list version )

#
# @brief  List nfs mounted disks
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nfslist
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __nfslist() {
	__checktool "$SHOWMOUNT"
	STATUS=$?
	if [ "$STATUS" -eq "$SUCCESS" ]; then
		eval "showmount -a"
		return $SUCCESS
	fi
    return $NOT_SUCCESS
}

#
# @brief  Get version of nfs server
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nfsversion
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __nfsversion() {
	__checktool "$NFSSTAT"
	STATUS=$?
	if [ "$STATUS" -eq "$SUCCESS" ]; then
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
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __nfsoperation() {
    OPERATION=$1
    if [ -n "$OPERATION" ]; then
		__checktool "$SYSTEMCTL"	
		STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$OPERATION" == "list" ]; then
	        	__nfslist
				return $SUCCESS
		    fi
			if [ "$OPERATION" == "version" ]; then
				__nfsversion
				return $SUCCESS
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
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nfsmanager "$OPERATION"
#
function __nfsmanager() {
    OPERATION=$1
    if [ -n $OPERATION ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[NFS Server Manager]"
		fi
        __checkop "$OPERATION" "${NFS_OP_LIST[*]}"
        STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
			LOG[MSG]="$OPERATION NFS Server"
            if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "[Info] ${LOG[MSG]}"
            fi
            __nfsoperation "$OPERATION"
			__logging $LOG
            if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n\n" "[Done]"
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
# @exitval Script tool atmanger exit with integer value
#			0   - success operation 
# 			127 - run as root user
#			128 - missing argument
#			129 - wrong argument (operation)
#
printf "\n%s\n%s\n\n" "$TOOL_NAME $TOOL_VERSION" "`date`"
__checkroot
STATUS=$?
if [ "$STATUS" -eq "$SUCCESS" ]; then
	__nfsmanager "$1"
fi

exit 127

