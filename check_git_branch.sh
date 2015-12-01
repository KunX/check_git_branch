#!/bin/sh
#
# Check which branch is checked out on a git working directory and alerts if different from specified
# Version 0.1
#
# by Diogo Uchoas Correa ( diogo.correa@animaeducacao.com.br )
# 

STATE_OK=0
STATE_WARNING=1
STATE_CRITICALITICAL=2
STATE_UNKNOWN=3
CMDS="git"

if [ $# -eq 0 ]; then
    echo "Please specify folder and branch options."
    exit $STATE_UNKNOWN
fi
while getopts ":f:"":b:""h" opt 
do
    case "$opt" in
        f) 
			folder=$OPTARG
		;;
        b) 	
			branch=$OPTARG
		;;
		h) 
			echo "Syntax: $0 -f <git repository folder> -b <branch name>"
           	exit $STATE_UNKNOWN 
		;;
		*)
			echo "Syntax: $0 -f <git repository folder> -b <branch name>"
            exit $STATE_UNKNOWN
		;;
    esac
done

if [ -z "$folder" ];then 
	echo "folder variable is empty"
	exit $STATE_UNKNOWN
fi
if [ -z "$branch" ]; then
	echo "branch variable is empty"
	exit $STATE_UNKNOWN
fi

if [ -d $folder ]; then
	cd $folder
	if [ -d .git ]; then
		current_branch=`git branch |grep '*'|awk -F" " '{print $2}'`
		if [ "$current_branch" = "$branch" ]; then
		        echo "OK - Branch $branch checked out"
        		exit $STATE_OK
		else
        		echo "Critical - Branch $current_branch checked out. Expected branch was $branch"
        		exit $STATE_WARNING
		fi      
	else
		echo "The specified folder is not a git repository"
		exit $STATE_UNKNOWN
	fi
else
	echo "The specified folder doesn't exist."
	exit $STATE_UNKNOWN
fi
