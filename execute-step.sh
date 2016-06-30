#!/usr/bin/env bash

if [ $ENABLE_INIT_DAEMON = "true" ]
   then
       echo "Execute step ${INIT_DAEMON_STEP} in pipeline"
       while true; do
           sleep $SLEEP_EXEC
           msg="$INIT_DAEMON_BASE_URI/execute?step=$INIT_DAEMON_STEP"
           printf "execute : sent [%s]\n" $msg
           string=$(curl -sL -w "%{http_code}" -X PUT $msg -d "" -o /dev/null)
           printf "execute : Got back string : [%s]\n"  $string

           [ "$string" = "204" ] && break;

           printf "sleeping\n"
       done
       echo "Notified execution of step ${INIT_DAEMON_STEP}"
fi


