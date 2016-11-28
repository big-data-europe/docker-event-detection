#!/usr/bin/env bash

# Init-daemon address, start and mark execute
##############################################
if [ $ENABLE_INIT_DAEMON = "true" ]; then
	
	if [ "$DAEMON_INITIALIZED" == "true" ]; then
		exit 0
	fi
	echo
	echo ">Running daemon interface setup script ($0)"
	echo "Resolving the daemon's address."
	echo  "----------------------------------"
	INIT_DAEMON_BASE_URI="${INIT_DAEMON_BASE_URI:-"UNSET"}"

	# Check whether the env. var is set and notify.
	if [   $INIT_DAEMON_BASE_URI = "UNSET" ] ; then
		echo "INIT_DAEMON_BASE_URI is unset."
	else
		echo "INIT_DAEMON_BASE_URI initially set to [$INIT_DAEMON_BASE_URI]."
	fi

	# Check whether we need to override the environment variable.
	echo "Checking daemon information file environment variable."

	# check wether the DAEMON_INFO_FILE var with daemon information is set
	DAEMON_INFO_FILE="${DAEMON_INFO_FILE:-"UNSET"}"
	if [ $DAEMON_INFO_FILE = "UNSET" ] ; then
		echo "The DAEMON_INFO_FILE variable is not set."
	fi

	# Check wether a file was indeed supplied in the container, at the
	# location specified by DAEMON_INFO_FILE.
	echo "Checking for override file at [$DAEMON_INFO_FILE]."
	if [ ! -f $DAEMON_INFO_FILE ] ; then
		echo "Override file $DAEMON_INFO_FILE does not exist."
	else
		# purge whitespace and set
		INIT_DAEMON_BASE_URI=$( cat $DAEMON_INFO_FILE | tr -d " \n\t\r")
		echo "INIT_DAEMON_BASE_URI set to [$INIT_DAEMON_BASE_URI] from supplied override file."
		# TODO check for correct address  (IP+port) structure
		# or, later, for correct http addr structure
	fi
		
	if [   $INIT_DAEMON_BASE_URI = "UNSET" ] ; then
		(>&2 echo "Failed to initialize remote daemon's address!")
		(>&2 echo "You need to supply the daemon's address either by setting a default INIT_DAEMON_BASE_URI,")
		(>&2 echo "Or by writing the address to an override file, ")
		(>&2 echo "mounted on the container and set the path to DAEMON_INFO_FILE.")
		exit
	fi
	echo "Configured daemon's interface url as [$INIT_DAEMON_BASE_URI]"
	echo  "----------------------------------"
	export INIT_DAEMON_BASE_URI
	export DAEMON_INITIALIZED="true"
	echo "-Done running the daemon setup script."
fi
echo
