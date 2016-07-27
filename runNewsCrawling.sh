#!/usr/bin/env bash

echo ">Running news crawler."

modulefolder="$BDEROOT/BDEEventDetection/BDERSSCrawler"
configfile="$modulefolder/res/newscrawler_configuration.properties"

java -cp "$JARCLASSPATH"  gr.demokritos.iit.crawlers.rss.NewsCrawler "$configfile"

echo "-Done running news crawler."