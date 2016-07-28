#!/usr/bin/env bash

echo "Running twitter crawler."

if [ -z $JARCLASSPATH ]; then
	bash $EXECDIR/setClassPath.sh
	JARCLASSPATH="$(cat $CLASSPATHFILE)"
fi

modulefolder="$BDEROOT/BDEEventDetection/BDETwitterListener"

twitterproperties="$modulefolder/res/twitter.properties"
twitterqueries="$modulefolder/res/twitter.queries"
mode="search"

execute="java -cp $JARCLASSPATH  gr.demokritos.iit.crawlers.twitter.CrawlSchedule  -o $mode -p $twitterproperties -q $twitterqueries"
#echo "$execute"
$execute
echo "-Done running twitter crawler."
