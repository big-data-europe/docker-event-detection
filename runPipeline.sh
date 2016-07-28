#!/usr/bin/env bash

if [ -z $JARCLASSPATH ]; then
	bash $EXECDIR/setClassPath.sh
	JARCLASSPATH="$(cat $CLASSPATHFILE)"
fi

# Script to run the entire event detection pipeline
echo "Running entire bde event detection pipeline."
$EXECDIR/runNewsCrawling.sh 
$EXECDIR/runTwitterCrawling.sh 
$EXECDIR/runLocationExtraction.sh 
$EXECDIR/runEventClustering.sh

