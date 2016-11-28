#!/usr/bin/env bash

# Init-daemon address, start and mark execute
##############################################
if [ $ENABLE_INIT_DAEMON = "true" ]; then
	mode="$1"
	task="$2"
	echo ">Running daemon interface script at mode [$mode] for task [$task]."
	if [ "$mode" ==  "init" ]; then
		# get permission to initialize
		echo
		echo "Daemon - initialization:"
		$DAEMON_DIRECTORY/wait-for-step.sh "$task"
		exit 0
	elif [ "$mode" ==  "exec" ]; then
		# notify execution
		echo
		echo "Daemon - execution:"
		$DAEMON_DIRECTORY/execute-step.sh "$task"
		echo
	elif [ "$mode" ==  "finish" ]; then
		echo "Daemon - finish:"
		$DAEMON_DIRECTORY/finish-step.sh "$task"
	else
		echo "Undefined daemon mode [$mode]"
		exit 1
	fi

echo "-Done running the daemon interface script."
echo

fi


