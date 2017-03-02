#!/usr/bin/env bash

# script to check logs easily

filename="$1"
if [ $# -lt 1 ]; then
	# check latest
	filename="$(ls $LOG_DIR -1t | head -1 )"
fi

cat "${LOG_DIR}/${filename}"
