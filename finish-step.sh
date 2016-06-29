#!/bin/bash

if [ $ENABLE_INIT_DAEMON = "true" ]
   then
       echo "Finish step ${INIT_DAEMON_STEP} in pipeline"
       while true; do
           sleep $SLEEP_FINISH
           msg="$INIT_DAEMON_BASE_URI/finish?step=$INIT_DAEMON_STEP"
           printf "finish : sent [%s]\n" $msg
           string=$(curl -sL -w "%{http_code}" -X PUT $msg -d "" -o /dev/null)
           printf "finish : Got back string : [%s]\n" $string

           [ "$string" = "204" ] && break
           printf "sleeping\n"
       done
       echo "Notified finish of step ${INIT_DAEMON_STEP}"
fi








