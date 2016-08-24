#!/usr/bin/env bash

# Script to set cassandra connection host, port and twitter credentials
# to the relevant BDE Event detection pilot configuration files.
# expected arguments: path to an input file

# the input file should contain two lines, as below:
# twitterConsumerKey twitterConsumerKeySecret twitterAccessTokken twitterAccessTokkenSecret
# host port

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
echo ">Setting cassandra connection parameters and twitter credentials."

# defaults. Twitter default credentials will obviously not work.
twitterConsumerKey="defaultConsumerKey"
twitterConsumerKeySecret="defaultConsumerKeySecret"
twitterAccessTokken="defaultAccessToken"
twitterAccessTokkenSecret="defaultAccessTokenSecret"
connectionIP="127.0.0.1"
connectionPort="9042"

# errors below should happen only when calling this script out of context
if [ -z $BDE_ROOT_DIR ]; then
	>&2 echo "Warning: Unset BDE root folder variable."
	exit 1
fi
if [ -z $1 ]; then
	>&2 echo "Warning: Unset argument variable to $0"
	useDefaults

elif  [ ! -f $1 ]; then
	>&2 echo "Warning: The configuration file $1 does not exist."
	useDefaults
	
else
	# read the file
	echo "Using configuration file $1"
	# 1st line for twitter creds
	twitterInfo="$(sed '1q;d' $1)"  
	# check
	if [ $(echo $twitterInfo | wc -w ) -ne 4 ]; then
		echo "asd"
		>&2 echo "***Error : Malformed file.Need 4 items for twitter credentials. Check the readme file."
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
paths="$BDE_ROOT_DIR/BDEEventDetection/BDECLustering/res/clustering.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/location_extraction.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/newscrawler_configuration.properties"
# newline-delimit, let's not change IFS
paths="$(echo $paths | sed  's/ /\n/g' )"

# sed the files with cassandra host/port
echo "Setting cassandra host:[$connectionIP] , port:[$connectionPort] to"
for f in $paths ; do
	echo -e "\t[$f]"
	sed -i "s/cassandra_hosts.*/cassandra_hosts=$connectionIP/g" $f
	sed -i "s/cassandra_port.*/cassandra_port=$connectionPort/g" $f
done

# set the twitter credentials
echo "Setting twitter credentials:"
filepath="$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.properties";
printf "\t[%s]\n\t[%s]\n\t[%s]\n\t[%s] \nto\n\t[%s]\n\n" "$twitterConsumerKey" "$twitterConsumerKeySecret" \
		"$twitterAccessTokken" "$twitterAccessTokkenSecret"  "$filepath"
sed -i "s/twitterConsumerKey=.*/twitterConsumerKey=$twitterConsumerKey/g" $filepath
sed -i "s/twitterConsumerKeySecret=.*/twitterConsumerKeySecret=$twitterConsumerKeySecret/g" $filepath
sed -i "s/twitterAccessTokken=.*/twitterAccessTokken=$twitterAccessTokken/g" $filepath
sed -i "s/twitterAccessTokkenSecret=.*/twitterAccessTokkenSecret=$twitterAccessTokkenSecret/g"  $filepath

echo "-Done setting connection information."; echo