#!/usr/bin/env bash

editor="nano"

# auth files to modify
paths="$MOUNT_DIR/connections/cassandra.conf"
paths+=" $MOUNT_DIR/connections/mysql.conf"
paths+=" $MOUNT_DIR/connections/twitter.conf"
for p in $paths ; do
	if [ ! -f "$p" ]; then
		/skel.sh auth
	fi
		$editor $p
done

