#!/usr/bin/env bash

# script to check logs easily

filename="$1"
if [ $# -lt 1 ]; then
	# check latest
	filename="$LOG_DIR/$(ls $LOG_DIR -1t | head -1 )"
fi
cat "$filename"
