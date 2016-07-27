#!/usr/bin/env bash


# Script to run the entire event detection pipeline
echo "Running entire bde event detection pipeline."
$EXECDIR/runNewsCrawling.sh 
$EXECDIR/runTwitterCrawling.sh 
$EXECDIR/runLocationExtraction.sh 
$EXECDIR/runEventClustering.sh

