#!/usr/bin/env bash

# Script to set cassandra/mysql connection host, port and twitter credentials
# to the relevant BDE Event detection pilot configuration files.


function usage {
	echo
	echo "Connection configuration 2-line file format:"
	echo "key keysecret token tokensecret" # twitter
	echo "cassandra-host-ip cassandra-host-port" # cassandra
	echo
}

function useDefaults {
	echo "Using default values for the cassandra ip/port and twitter credentials:"
	echo "twitterConsumerKey=defaultConsumerKey"
	echo "twitterConsumerKeySecret=defaultConsumerKeySecret"
	echo "twitterAccessTokken=defaultAccessToken"
	echo "twitterAccessTokkenSecret=defaultAccessTokenSecret"
	echo "cassandraHostIP=127.0.0.1"
	echo "cassandraPort=9042"
}
echo
echo ">Setting cassandra/mysql connection parameters and twitter credentials."



# property files to modify
paths="$BDE_ROOT_DIR/BDEEventDetection/BDECLustering/res/clustering.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/location_extraction.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/newscrawler_configuration.properties"

# newline-delimit, let's not change IFS
paths="$(echo $paths | sed  's/ /\n/g' )"


echo "Setting repository connection parameters and twitter credentials."

## TWITTER
# format expected:
# twitterConsumerKey
# twitterConsumerKeySecret
# twitterAccessTokken
# twitterAccessTokkenSecret
twitterfile="$CONNECTIONS_CONFIG_FOLDER/twitter.conf"
if [ -f "$twitterfile" ]; then

	twitterConsumerKey="$(cat $twitterfile | head -1 | tail -1)"
	twitterConsumerKeySecret="$(cat $twitterfile | head -2 | tail -1)"
	twitterAccessTokken="$(cat $twitterfile | head -3 | tail -1)"
	twitterAccessTokkenSecret="$(cat $twitterfile | head -4 | tail -1)"


	printf "Setting twitter :\n"
	printf "\tkey: [%s]\n" $twitterConsumerKey
	printf "\tkeysecret: [%s]\n" $twitterConsumerKeySecret
	printf "\tacctoken: [%s]\n" $twitterAccessTokken
	printf "\tacctokensecret: [%s]\n" $twitterAccessTokkenSecret

        twitterpropsfile="$BDE_ROOT_DIR/BDETwitterListener/res/twitter.properties"
        if [ ! -f "$twitterpropsfile" ]; then
                echo >&2 "File [$twitterpropsfile] not found "
        else
        # set the twitter credentials
                sed -i "s/twitterConsumerKey=.*/twitterConsumerKey=$twitterConsumerKey/g" "$twitterpropsfile"
                sed -i "s/twitterConsumerKeySecret=.*/twitterConsumerKeySecret=$twitterConsumerKeySecret/g" "$twitterpropsfile"
                sed -i "s/twitterAccessTokken=.*/twitterAccessTokken=$twitterAccessTokken/g" "$twitterpropsfile"
                sed -i "s/twitterAccessTokkenSecret=.*/twitterAccessTokkenSecret=$twitterAccessTokkenSecret/g" "$twitterpropsfile"
        fi



else
	echo "(!) No twitter credentials were found at [$twitterfile]!"
fi




# CASSANDRA
# expecting format:
# cassandra_hosts
# cassandra_port
# cassandra_keyspace
# cassandra_cluster_name

cassandrafile="$CONNECTIONS_CONFIG_FOLDER/cassandra.conf"

if [  -f "$cassandrafile" ] ; then

	cassandraHost="$(cat $cassandrafile | head -1 | tail -1)"
	cassandraPort="$(cat $cassandrafile | head -2 | tail -1)"
	cassandraKeyspace="$(cat $cassandrafile | head -3 | tail -1)"
	cassandraCluster="$(cat $cassandrafile | head -4 | tail -1)"

	printf "\nSetting cassandra:\n"
	printf "\thost: [%s]\n" $cassandraHost
	printf "\tport: [%s]\n" $cassandraPort
	printf "\tkeyspace: [%s]\n" $cassandraKeyspace
	printf "\tclustname: [%s]\n" $cassandraCluster
	printf "\n\tto files:\n"

	for f in $paths ; do
		printf "\t%s\n" "$f"
                [ ! -f $f ] && echo >&2 "File [$f] not found" && continue;

		sed -i "s/cassandra_hosts.*/cassandra_hosts=$cassandraHost/g" $f
		sed -i "s/cassandra_port.*/cassandra_port=$cassandraPort/g" $f
		sed -i "s/cassandra_keyspace.*/cassandra_keyspace=$cassandraKeyspace/g" $f
		sed -i "s/cassandra_cluster_name.*/cassandra_cluster_name=$cassandraCluster/g" $f
	done

else
	echo "(!) No cassandra settings were found at [$cassandrafile]"
fi

# MYSQL
# expecting format:
# databaseHost
# databaseName
# databaseUsername
# databasePassword
mysqlfile="$CONNECTIONS_CONFIG_FOLDER/mysql.conf"
if [ -f "$mysqlfile" ]; then

	mysqlinfo="$(cat $mysqlfile | grep -v '#')"
	databaseHost="$(cat $mysqlfile | head -1 | tail -1)"
	databaseName="$(cat $mysqlfile | head -2 | tail -1)"
	databaseUsername="$(cat $mysqlfile | head -3 | tail -1)"
	databasePassword="$(cat $mysqlfile | head -4 | tail -1)"

	printf "Setting mysql:\n"
	printf "\thost: [%s]\n" $databaseHost
	printf "\tdbname: [%s]\n" $databaseName
	printf "\tusername: [%s]\n" $databaseUsername
	printf "\tpass: [%s]\n" $databasePassword
	printf "\n\tto files:\n"
	for f in $paths ; do

		printf "\t%s\n" "$f"
                [ ! -f $f ] && echo >&2 "File [$f] not found" && continue;

		sed -i "s<databaseHost.*<databaseHost=$databaseHost<g" $f
		sed -i "s<databasename.*<databasename=$databaseName<g" $f
		sed -i "s<databaseUsername.*<databaseUsername=$databaseUsername<g" $f
		sed -i "s<databasePassword.*<databasePassword=$databasePassword<g" $f
	done

	else
		echo "(!) No cassandra settings were found at [$mysqlfile]"
fi


echo "-Done setting connection information."; echo
