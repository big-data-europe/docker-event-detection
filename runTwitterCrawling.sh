#!/usr/bin/env bash

echo "Running twitter crawler."

modulefolder="$BDEROOT/BDEEventDetection/BDETwitterListener"

twitterproperties="$modulefolder/res/twitter.properties"
twitterqueries="$modulefolder/res/twitter.queries"
mode="search"

java -cp "$JARCLASSPATH"  gr.demokritos.iit.crawlers.twitter.CrawlSchedule \
			 -o "$mode" -p "$twitterproperties" -q "$twitterqueries"
echo "-Done running twitter crawler."
