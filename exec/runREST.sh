#!/usr/bin/env bash

# script to run REST services
# first argument should be the REST name, which should match its sources folder


echo ">Running BDE Event detection REST script with argument [$1]. ($0)"

restName="$1"
if [ ! -d "$REST_SERVICES_DIR/$restName" ]; then
	>&2 echo "Rest service [$restName] not found in [$REST_SERVICES_DIR]" 
	exit 1
fi

if [ ! -f "$REST_SERVICES_DIR/$restName/run.sh" ]; then
	>&2 echo "Rest service execution script [$REST_SERVICES_DIR/$restName/run.sh] not found." 
	exit 1
fi
 
$REST_SERVICES_DIR/$restName/run.sh

echo "-Done running BDE Event detection REST script with argument [$1]."; echo
