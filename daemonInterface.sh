#!/usr/bin/env bash

# Init-daemon address, start and mark execute
##############################################
if [ $ENABLE_INIT_DAEMON = "true" ]; then
	echo "Running daemon interface script."

	echo "Resolving the daemon's address."
	echo  "----------------------------------"
	INIT_DAEMON_BASE_URI="${INIT_DAEMON_BASE_URI:-"UNSET"}"

	# Check whether the env. var is set and notify.
	if [   $INIT_DAEMON_BASE_URI = "UNSET" ] ; then
		echo "INIT_DAEMON_BASE_URI is unset."
	else
		echo "INIT_DAEMON_BASE_URI initially set to [$INIT_DAEMON_BASE_URI] from environment var."
	fi

	# Check whether we need to override the environment variable.
	echo "Checking daemon information file env var."

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
		
	echo  "----------------------------------"


	export INIT_DAEMON_BASE_URI
	# Maybe you want to set the step name
	#INIT_DAEMON_STEP="TEST_STEP"
	echo 
	echo "Running step $INIT_DAEMON_STEP."

	# get permission to initialize
	echo
	echo "Daemon - validation:"
	$DAEMON_DIR/wait-for-step.sh
	
	# put initialization code of the container here
	# dummy run
	echo "Here the container should initialize, if needed."
	echo "Dummy initializing...done"
	echo

	# notify execution
	echo
	echo "Daemon - execution:"
	$DAEMON_DIR/execute-step.sh

	
	echo
else
	# if the init daemon is disabled, initialize here instead.
	# put initialization code of the container here
	# dummy run
	echo "Daemon interface is disabled"
	echo "Here the container should initialize, if needed."
	echo "Dummy initializing...done"
	echo

fi


# put execution code of the container here

$EXECDIR/run.sh $1


# notify end of execution

if [ $ENABLE_INIT_DAEMON = "true" ]; then
	echo "Daemon - finish:"
	$DAEMON_DIR/finish-step.sh
fi
echo "Done."

