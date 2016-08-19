#!/usr/bin/env bash

# Script to run the entire event detection pipeline
echo "#############################################"
echo "Running entire bde event detection pipeline."
echo "#############################################"

export LOG_PREFIX="pipeline_"
echo "Per-component logs are at $LOG_DIR"
echo
echo "###"; echo;
$EXEC_DIR/runNewsCrawling.sh 
echo "###"; echo;
$EXEC_DIR/runTwitterCrawling.sh 
echo "###"; echo;
$EXEC_DIR/runLocationExtraction.sh 
echo "###"; echo;
$EXEC_DIR/runEventClustering.sh 
echo "Done running pipeline."; 
echo "######################";

