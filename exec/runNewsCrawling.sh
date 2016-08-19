#!/usr/bin/env bash

echo ">>>Running news crawler."

if [ -z $JARCLASSPATH ]; then
	bash $EXEC_DIR/setClassPath.sh
	JARCLASSPATH="$(cat $CLASSPATHFILE)"
fi

modulefolder="$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler"
configfile="$modulefolder/res/newscrawler_configuration.properties"


execute="java -cp $JARCLASSPATH  gr.demokritos.iit.crawlers.rss.NewsCrawler $configfile"
#echo "$execute"
logfile="$($EXEC_DIR/setLogfileName.sh newscrawl $LOG_DIR $LOG_PREFIX)"
echo "Writing log to $logfile"
$execute 2>&1 | tee  "$logfile"

echo "---Done running news crawler."