#!/usr/bin/env bash
task="$1"
if [ $ENABLE_INIT_DAEMON = "true" ]
   then
       echo "Execute step ${task} in pipeline"
       while true; do
           sleep $SLEEP_EXEC
           msg="$INIT_DAEMON_BASE_URI/execute?step=$task"
           printf "execute : sent [%s]\n" $msg
           string=$(curl -sL -w "%{http_code}" -X PUT $msg -d "" -o /dev/null)
           printf "execute : Got back string : [%s]\n"  $string

           [ "$string" = "204" ] && break;
           printf "sleeping for %d seconds.\n" $SLEEP_EXEC
       done
       echo "Notified execution of step ${task}"
fi


