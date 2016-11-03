#!/usr/bin/env bash

echo ">>>Running twitter crawler. ($0)"

if [ -z $JARCLASSPATH ]; then
	bash $EXEC_DIR/setClassPath.sh
	JARCLASSPATH="$(cat $CLASSPATHFILE)"
fi
twitterproperties="$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.properties"
execute="java -cp $JARCLASSPATH  gr.demokritos.iit.crawlers.twitter.CrawlSchedule $twitterproperties"
#echo "$execute"
logfile="$($EXEC_DIR/setLogfileName.sh twittercrawl $LOG_DIR $LOG_PREFIX)"
echo "Writing log to $logfile"
$execute 2>&1 | tee  "$logfile"

echo "---Done running twitter crawler."
