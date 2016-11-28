#!/usr/bin/env bash

# entrypoint script for BDE event detection
echo ">Running BDE event detection driver script.($0)"

if [ -z $BDE_ROOT_DIR ]; then
	echo >&2 "There is a problem with the environment variables setting:"
	echo >&2"BDE_ROOT_DIR is not set! Exiting."
	exit 1
fi
# setup the daemon
bash $DAEMON_DIRECTORY/setup.sh 

bash $EXEC_DIR/run.sh "$@"

echo "-Done running BDE event detection driver script."
