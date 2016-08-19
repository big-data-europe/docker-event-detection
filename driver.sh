#!/usr/bin/env bash

# entrypoint script for BDE event detection
echo ">Running BDE event detection driver script."

if [ -z $BDE_ROOT_DIR ]; then
	echo >&2 "There is a problem with the environment variables setting:"
	echo >&2"BDE_ROOT_DIR is not set! Exiting."
	exit 1
fi

bash $DAEMON_DIRECTORY/daemonInterface.sh $1
echo "-Done running BDE event detection driver script."
