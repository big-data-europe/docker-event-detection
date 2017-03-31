#!/usr/bin/env bash
echo "Starting entrypoint script execution"
echo "===================================="

# event detection container entrypoint script
# copy default parameters
# /skel.sh all

# initialize modules
/driver.sh init


# start twitter rest service
/driver.sh rest twitterRest

# mark successful init
service tomcat7 status
if [ -s $ERROR_FILE ]; then

	echo >&2 "Errors occured:"
	echo >&2 "[$ERROR_FILE] contents:"
	echo "-----------------"
	cat $ERROR_FILE
	echo "-----------------"
else

	echo "Successful initialization!"
	echo "OK" >> "$HEALTHCHECK_FILE"

	echo "Finished entrypoint script execution"
	echo "===================================="
	echo;
	echo "Starting to monitor latest logfile at [$LOG_DIR] directory:"
	echo "---------------------------------------------------------------"
	tail -n 20 -f "$( find $LOG_DIR -type f | head -1 )"
	#tail -f "$HEALTHCHECK_FILE"

fi



