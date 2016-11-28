#!/usr/bin/env bash
# Wrapper for initialization execution script

# check whether initialization already took place to abort
if [ -f  "$INITIALIZATION_FILE" ]; then
	# do not abort if it was asked to run initialization via the init argument
	if [ "$1" == "init" ]; then
		echo "(!) Forcing re-initialization due to parameter [$1]"
	else
		echo "Initialization has already been performed, returning."
		exit 0
	fi
fi

# run the initialization

# set up an initialization log file
logfile="$($EXEC_DIR/setLogfileName.sh initialization $LOG_DIR "")"
$EXEC_DIR/initialize.sh 2>&1 | tee  "$logfile"