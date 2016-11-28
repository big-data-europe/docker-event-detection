#!/usr/bin/env bash
task="$1"
if [ $ENABLE_INIT_DAEMON = "true" ]
   then
       echo "Validating if step ${task} can start in the pipeline"
       while true; do
           sleep $SLEEP_WAIT
           msg="$INIT_DAEMON_BASE_URI/canStart?step=$task"
           printf "wait : sent [%s]\n" $msg
           string=$(curl -sL -w "%{http_code}" -X PUT $msg -d "" -o /dev/null)
           printf "wait : Got back string : [%s]\n" $string

           [ "$string" = "204" ] && break;
           printf "sleeping for %d seconds.\n" $SLEEP_WAIT
       done
       echo "Can start step ${task} in the pipeline"
fi
