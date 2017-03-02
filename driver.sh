#!/usr/bin/env bash

# entrypoint script for BDE event detection
echo ">Running BDE event detection driver script.($0)"

# setup the daemon
bash $DAEMON_DIRECTORY/setup.sh 

bash $EXEC_DIR/run.sh "$@"

echo "-Done running BDE event detection driver script."
