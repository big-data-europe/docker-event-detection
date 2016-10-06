#!/usr/bin/env bash

editor="nano"

# property files to modify
# property files to modify
paths="$BDE_ROOT_DIR/BDEEventDetection/BDECLustering/res/clustering.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/location_extraction.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/newscrawler_configuration.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/blogcrawler_configuration.properties"

for p in $paths ; do
	[ ! -f "$p" ] && echo "File [$p] does not exist (run initialization first ?)." && continue
	echo "[$p]"
	$editor $p
done

