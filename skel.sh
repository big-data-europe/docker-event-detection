#!/usr/bin/env bash
# make skel authentication  and property files
echo ;echo ">Running the skeleton file script ($0)"; echo ;
[ $# -lt 1 ] && echo "Usage: $(basename $0) <auth | prop | src | all>" && exit 1
OPTS=""
[ $# -gt 1 ] && OPTS="$2"

direc="$BDE_ROOT_DIR/BDEEventDetection/skel_property_files";

echo "Copying skel files from $direc to $MOUNT_DIR"

mkdir -p $CONNECTIONS_CONFIG_FOLDER

for arg in "$@"; do
    if [ "$arg"=="auth" ] || [ "$arg"=="all" ] ; then

		f="$CONNECTIONS_CONFIG_FOLDER/cassandra.conf"
		[ ! -f "$f" ]  && touch "$CONNECTIONS_CONFIG_FOLDER/cassandra.conf"

		f="$CONNECTIONS_CONFIG_FOLDER/mysql.conf"
		[ ! -f "$f" ] && touch "$CONNECTIONS_CONFIG_FOLDER/mysql.conf"

		f="$CONNECTIONS_CONFIG_FOLDER/twitter.conf"
		[ ! -f "$f" ] && touch "$CONNECTIONS_CONFIG_FOLDER/twitter.conf"
		[ ! "$arg"=="all" ] && continue
	fi

    if [ "$arg"=="props" ] || [ "$arg"=="all" ]; then
		cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/"*.properties "$MOUNT_DIR/"
		[ ! "$arg"=="all" ] && continue
	fi
    if [ "$arg"=="src" ] || [ "$arg"=="all" ]; then
		
		cp $direc/*.queries $direc/*.accounts $direc/*.urls "$MOUNT_DIR/"
		[ ! "$arg"=="all" ] && continue
	fi
    [  "$arg"=="all" ] && exit 0
    echo "Undefined arg [$arg]"
    exit 1
    
done

exit 0
