#!/usr/bin/env bash

echo ">>>Running twitter crawler."

if [ -z $JARCLASSPATH ]; then
	bash $EXEC_DIR/setClassPath.sh
	JARCLASSPATH="$(cat $CLASSPATHFILE)"
fi

modulefolder="$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener"

twitterproperties="$modulefolder/res/twitter.properties"
twitterqueries="$modulefolder/res/twitter.queries"

# provide an argument for mode specification
mode="search"
if [ "$#" -gt 0 ]; then
	if [ "$1" == "search" ]; then
		mode="search";
	elif [ "$1" == "monitor" ]; then 
		mode="monitor"; 
	elif [ "$1" == "stream" ]; then 
		mode="stream"; 
	else 
		echo "Undefined twitter crawler operation mode :[$1]";
		exit 1;
	fi
	echo "Set twitter crawler mode to [$mode]"
fi


execute="java -cp $JARCLASSPATH  gr.demokritos.iit.crawlers.twitter.CrawlSchedule  -o $mode -p $twitterproperties -q $twitterqueries"
#echo "$execute"
logfile="$($EXEC_DIR/setLogfileName.sh twittercrawl $LOG_DIR $LOG_PREFIX)"
echo "Writing log to $logfile"
$execute 2>&1 | tee  "$logfile"

echo "---Done running twitter crawler."
