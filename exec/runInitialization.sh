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
# check whether we need to actually run the initialization:
# check whether the "help" argument was provided
# print help
if [ "$#" -eq 1  ] && [ "$1" == "help" ]; then
	echo "Initialization usage:"
	echo "User-provided override file (container) paths:"
	echo "news properties [$SUPPLIED_NEWS_PROPS_FILE]"
	echo "news urls [$SUPPLIED_NEWS_URLS_FILE]"
	echo "clustering properties [$SUPPLIED_CLUSTER_PROPS_FILE]"
	echo "location properties [$SUPPLIED_LOCATION_PROPS_FILE]"
	echo "twitter queries [$SUPPLIED_TWITTER_QUERIES_FILE]"
	echo "twitter properties [$SUPPLIED_TWITTER_PROPS_FILE]" 
	echo
	exit 0
elif [ "$1" == "rest" ]; then
	echo "Will not run initialization in rest mode."
	exit 0
fi

# set up an initialization log file
logfile="$($EXEC_DIR/setLogfileName.sh initialization $LOG_DIR "")"
$EXEC_DIR/initialize.sh 2>&1 | tee  "$logfile"