#!/usr/bin/env bash

# Script to set cassandra connection host, port and twitter credentials
# to the relevant BDE Event detection pilot configuration files.
# expected arguments: configurationFilePath

# format expected in the file:
# twitterConsumerKey twitterConsumerKeySecret twitterAccessTokken twitterAccessTokkenSecret
# host port
function usage {
	echo
	echo "Connection configuration 2-line file format:"
	echo "key keysecret token tokensecret" # twitter
	echo "cassandra-host-ip cassandra-host-port" # cassandra
	echo
}

echo "Setting cassandra connection parameters and twitter credentials."

# defaults
twitterConsumerKey="defaultConsumerKey"
twitterConsumerKeySecret="defaultConsumerKeySecret"
twitterAccessTokken="defaultAccessToken"
twitterAccessTokkenSecret="defaultAccessTokenSecret"
connectionIP="127.0.0.1"
connectionPort="9042"

# should happen only due to cosmic radiation flipping bits in ram
# or due to calling this script out of context
if [ $# -ne 1 ]; then
	>&2 echo "$0 needs exactly one argument."
	usage
	exit 1
fi
# cosmic radiation also 
if [ -z $1 ]; then
	>&2 echo "Unset argument variable to $0"
	usage
	exit 1
fi

# no file provided
if [ ! -f $1 ]; then
	>&2 echo "Warning:The configuration file $1 does not exist."
	echo "Using default values for the cassandra ip/port and twitter credentials:"
	echo "twitterConsumerKey=defaultConsumerKey"
	echo "twitterConsumerKeySecret=defaultConsumerKeySecret"
	echo "twitterAccessTokken=defaultAccessToken"
	echo "twitterAccessTokkenSecret=defaultAccessTokenSecret"
	echo "cassandraHostIP=127.0.0.1"
	echo "cassandraPort=9042"

else
	# read the file
	echo "Using configuration file $1"
	# 1st line for twitter creds
	twitterInfo="$(sed '1q;d' $1)"  
	# check
	if [ $(echo $twitterInfo | wc -w ) -ne 4 ]; then
		echo "asd"
		>&2 echo "Need 4 items for twitter credentials. Check the readme file."
		usage
		exit 1
	fi
	# set
	twitterConsumerKey="$(echo $twitterInfo | awk '{print $1}')"
	twitterConsumerKeySecret="$(echo $twitterInfo | awk '{print $2}')"
	twitterAccessTokken="$(echo $twitterInfo | awk '{print $3}')"
	twitterAccessTokkenSecret="$(echo $twitterInfo | awk '{print $4}')"
	# 2nd line for cassandra host/port
	connectionInfo="$(sed '2q;d' $1)" 
	# check
	if [ $(echo $connectionInfo | wc -w ) -ne 2 ]; then
		>&2 echo "Need 2 items for connectivity options. Check the readme file."
		usage
		exit 1
	fi
	# set
	connectionIP="$(echo $connectionInfo | awk '{print $1}')"
	connectionPort="$(echo $connectionInfo | awk '{print $2}')"
fi

# files to modify
paths="/bde/BDEEventDetection/BDECLustering/res/clustering.properties"
paths+=" /bde/BDEEventDetection/BDETwitterListener/res/twitter.properties"
paths+=" /bde/BDEEventDetection/BDELocationExtraction/res/location_extraction.properties"
paths+=" /bde/BDEEventDetection/BDERSSCrawler/res/newscrawler_configuration.properties"
# newline-delimit, let's not change IFS
paths="$(echo $paths | sed  's/ /\n/g' )"

# sed the files with cassandra host/port
echo "Setting cassandra host-port..."
for f in $paths ; do
	echo "[$f]"
	sed -i "s/cassandra_hosts.*/cassandra_hosts=$connectionIP/g" $f
	sed -i "s/cassandra_port.*/cassandra_port=$connectionPort/g" $f
done
echo "Setting twitter credentials..."
# set the twitter credentials
sed -i "s/twitterConsumerKey=.*/twitterConsumerKey=$twitterConsumerKey/g" "/bde/BDEEventDetection/BDETwitterListener/res/twitter.properties"
sed -i "s/twitterConsumerKeySecret=.*/twitterConsumerKeySecret=$twitterConsumerKeySecret/g" "/bde/BDEEventDetection/BDETwitterListener/res/twitter.properties"
sed -i "s/twitterAccessTokken=.*/twitterAccessTokken=$twitterAccessTokken/g" "/bde/BDEEventDetection/BDETwitterListener/res/twitter.properties"
sed -i "s/twitterAccessTokkenSecret=.*/twitterAccessTokkenSecret=$twitterAccessTokkenSecret/g" "/bde/BDEEventDetection/BDETwitterListener/res/twitter.properties"

