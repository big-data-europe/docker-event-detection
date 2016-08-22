#!/usr/bin/env bash

if [ $ENABLE_INIT_DAEMON = "true" ]
   then
       echo "Validating if step ${INIT_DAEMON_STEP} can start in the pipeline"
       while true; do
           sleep $SLEEP_WAIT
           msg="$INIT_DAEMON_BASE_URI/canStart?step=$INIT_DAEMON_STEP"
           printf "wait : sent [%s]\n" $msg
           string=$(curl -s $msg)
           printf "wait : Got back string : [%s]\n" $string

           [ "$string" = "true" ] && break
           printf "sleeping for %d seconds.\n" $SLEEP_WAIT
       done
       echo "Can start step ${INIT_DAEMON_STEP} in the pipeline"
fi