#!/usr/bin/env bash
task="$1"
if [ $ENABLE_INIT_DAEMON = "true" ]
   then
       echo "Finish step ${task} in pipeline"
       while true; do
           sleep $SLEEP_FINISH
           msg="$INIT_DAEMON_BASE_URI/finish?step=$task"
           printf "finish : sent [%s]\n" $msg
           string=$(curl -sL -w "%{http_code}" -X PUT $msg -d "" -o /dev/null)
           printf "finish : Got back string : [%s]\n" $string

           [ "$string" = "204" ] && break;
           printf "sleeping for %d seconds.\n" $SLEEP_FINISH
       done
       echo "Notified finish of step ${task}"
fi








