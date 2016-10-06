#!/usr/bin/env bash

editor="nano"

paths="$BDE_ROOT_DIR/BDEEventDetection/BDECLustering/res/twitter.queries"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/blog_urls.txt"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/news_urls.txt"

for p in $paths ; do
	
	[ ! -f "$p" ] && echo "File [$p] does not exist (run initialization first ?)." && continue
	echo "[$p]"
	$editor $p
done
