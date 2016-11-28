#!/usr/bin/env bash

editor="nano"

paths="$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.queries"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.accounts"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/blogs.urls"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/news.urls"

for p in $paths ; do
	
	[ ! -f "$p" ] && echo "File [$p] does not exist (run initialization first ?)." && continue
	echo "[$p]"
	$editor $p
done
