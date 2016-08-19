#!/usr/bin/env bash
ID="$1"
DIR="$2"
PREF="$3"
# check if we're in a cronjob
if [ ! -z "$(ps -eo ppid,pid,cmd | awk '{p[$1]=p[$1]","$3}END{ for(i in p) print i, p[i]}' | grep '/usr/sbin/cron')" ] ; then
	PREF="scheduled_${PREF}"
fi
logfile="$DIR/${PREF}${ID}_$(date '+%d-%m-%Y-%H:%M:%S').log"
echo "$logfile"