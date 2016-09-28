#!/usr/bin/env bash
ID="$1"		# id is the operation that is run
DIR="$2"
PREF="$3"	# prefix serves as a run mode identifier (scheduled or not)
# check if we're in a cronjob
if [ ! -z "$(ps -eo ppid,pid,cmd | awk '{p[$1]=p[$1]","$3}END{ for(i in p) print i, p[i]}' | grep '/usr/sbin/cron')" ] ; then
	PREF="scheduled_${PREF}"
fi
logfile="$DIR/${PREF}${ID}_$(date '+%d-%m-%Y-%H:%M:%S').log"
echo "$logfile"