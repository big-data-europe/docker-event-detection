#!/usr/bin/env bash

# check if a configuration file was supplied 
# format expected:
# twitterConsumerKey twitterConsumerKeySecret twitterAccessTokken twitterAccessTokkenSecret
# host port

twitterConsumerKey=""
twitterConsumerKeySecret=""
twitterAccessTokken=""
twitterAccessTokkenSecret=""

if [ $# -eq 1 ]; then
	twitterInfo="$(sed '1q;d' $1)"  # 1st line
	if [ $(wc -w $(cat twitterInfo)) -ne 4 ]; then
		>&2 echo "Need 4 items for twitter credentials. Check the readme file."
		exit 1
	fi
	twitterConsumerKey="$(cat twitterInfo | awk '{print $1}')"
	twitterConsumerKeySecret="$(cat twitterInfo | awk '{print $2}')"
	twitterAccessTokken="$(cat twitterInfo | awk '{print $3}')"
	twitterAccessTokkenSecret="$(cat twitterInfo | awk '{print $4}')"

	connectionInfo="$(sed '2q;d' $1)"  # 2nd line
	if [ $(wc -w $(cat connectionInfo)) -ne 2 ]; then
		>&2 echo "Need 2 items for connectivity options. Check the readme file."
		exit 1
	fi
	connectionIP="$(cat connectionInfo | awk '{print $1}')"
	connectionPort="$(cat connectionInfo | awk '{print $2}')"

fi