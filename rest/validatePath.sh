#!/usr/bin/env bash

filepath="$1"

if [ ! -f "$filepath" ]; then
	>&2 echo "You need to provide a path/url to the git repository at the file [$filepath]."
	exit 1
fi
contents="$(cat $filepath | head -1 | awk '{$1=$1;print}')"

if [ -z "$contents" ]; then
	>&2 echo "You need to provide a path/url to the git repository."
	>&2 echo "Path/url file [$filepath] is empty-ish:"
	echo "[$(cat $filepath)]"
	exit 1
fi

exit 0
echo 