#!/usr/bin/env bash

echo ">Running news crawler."

if [ -z $JARCLASSPATH ]; then
	bash $EXECDIR/setClassPath.sh
	JARCLASSPATH="$(cat $CLASSPATHFILE)"
fi

modulefolder="$BDEROOT/BDEEventDetection/BDERSSCrawler"
configfile="$modulefolder/res/newscrawler_configuration.properties"

if [ -z $JARCLASSPATH ]; then
	JARCLASSPATH="$(find * -name *.jar | tr '\n' ':')"
fi

execute="java -cp $JARCLASSPATH  gr.demokritos.iit.crawlers.rss.NewsCrawler $configfile"
#echo "$execute"
$execute
echo "-Done running news crawler."