#!/usr/bin/env bash

echo ">>>Running blog crawler."

if [ -z $JARCLASSPATH ]; then
	bash $EXEC_DIR/setClassPath.sh
	JARCLASSPATH="$(cat $CLASSPATHFILE)"
fi

modulefolder="$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler"
configfile="$modulefolder/res/blogcrawler_configuration.properties"


execute="java -cp $JARCLASSPATH  gr.demokritos.iit.crawlers.rss.BlogCrawler $configfile"
#echo "$execute"
logfile="$($EXEC_DIR/setLogfileName.sh newscrawl $LOG_DIR $LOG_PREFIX)"
echo "Writing log to $logfile"
$execute 2>&1 | tee  "$logfile"

echo "---Done running blog crawler."