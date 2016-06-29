!/#bin/bash
echo "Running run.sh script."

# check wether env. var of host URI is set.
# if not, assign a flag value
echo "Resolving the daemon's address."
echo  "----------------------------------"
INIT_DAEMON_BASE_URI="${INIT_DAEMON_BASE_URI:-"UNSET"}"

if [   $INIT_DAEMON_BASE_URI = "UNSET" ] ; then
	echo "INIT_DAEMON_BASE_URI is unset."
else
	echo "INIT_DAEMON_BASE_URI is set to [$INIT_DAEMON_BASE_URI] from environment var."
fi

echo "Checking daemon information file env var."
# check wether the DAEMON_INFO_FILE var with daemon information is set
# this overrides the environment variable.
DAEMON_INFO_FILE="${DAEMON_INFO_FILE:-"UNSET"}"
if [ $DAEMON_INFO_FILE = "UNSET" ] ; then
	echo "The DAEMON_INFO_FILE variable is not set."
fi

# check wether the file was indeed supplied in the container and set it.
echo "Checking supplied file at [$DAEMON_INFO_FILE]."
if [ ! -f $DAEMON_INFO_FILE ] ; then
	echo "File $DAEMON_INFO_FILE does not exist."
else
	# purge whitespace and set
	INIT_DAEMON_BASE_URI=$( cat $DAEMON_INFO_FILE | tr -d " \n\t\r")
	echo "INIT_DAEMON_BASE_URI set to [$INIT_DAEMON_BASE_URI] from supplied file."
	# TODO check for correct IP+port structure
	# or, later, for correct http addr structure
fi
	
if [   $INIT_DAEMON_BASE_URI = "UNSET" ] ; then
	(>&2 echo "Failed to initialize remote daemon's address!.")
	(>&2 echo "You need to supply the daemon's address either by setting INIT_DAEMON_BASE_URI.")
	(>&2 echo "Or by writing it in a file, mounted on the container and set the path to DAEMON_INFO_FILE.")
	exit
fi
	
echo  "----------------------------------"

export INIT_DAEMON_BASE_URI
#INIT_DAEMON_STEP="TEST_STEP"
echo 
echo "Running step $INIT_DAEMON_STEP."
echo


echo
echo "Daemon - validation:"
$DAEMON_DIR/wait-for-step.sh

echo
echo "Daemon - execution:"
$DAEMON_DIR/execute-step.sh

# put execution code of the docker file here
echo
# dummy run
echo "Here the container should run its task. Sleeping for 2s"
sleep 2
echo

echo "Daemon - finish:"
$DAEMON_DIR/finish-step.sh

echo "Done."

