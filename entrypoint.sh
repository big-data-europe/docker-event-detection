#!/usr/bin/env bash

# event detection container entrypoint script
# copy default parameters
/skel.sh all

# initialize modules
/driver.sh init

# start twitter rest service
/driver.sh rest twitterRest

# mark successful global initialization
echo "OK" >> "$GLOBAL_INITIALIZATION_FILE"
