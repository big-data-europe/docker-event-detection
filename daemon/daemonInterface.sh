#!/usr/bin/env bash
echo
echo ">Running daemon interface script."
# Init-daemon address, start and mark execute
##############################################
if [ $ENABLE_INIT_DAEMON = "true" ]; then
	

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
	echo "Daemon - initialization:"
	$DAEMON_DIRECTORY/wait-for-step.sh
	
	# put initialization code of the container here
	echo "Running init-daemon-authorized BDE initialization"
	$EXEC_DIR/initialize.sh $1
	echo

	# notify execution
	echo
	echo "Daemon - execution:"
	$DAEMON_DIRECTORY/execute-step.sh

	
	echo
else

	# if the init daemon is disabled, initialize here instead.	
	echo "The init-daemon interface is disabled."
	echo "Running BDE initialization"
	$EXEC_DIR/initialize.sh  $1

fi


# put execution code of the container here

$EXEC_DIR/run.sh $1


# notify end of execution

if [ $ENABLE_INIT_DAEMON = "true" ]; then
	echo "Daemon - finish:"
	$DAEMON_DIRECTORY/finish-step.sh
fi
echo "-Done running the daemon interface script."
echo
