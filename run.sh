#!/usr/bin/env bash

# script to run the BDE event detection pipeline
# first argument specified scheduled vs single run
echo "Running BDE Event detection driver script."

# get all jars to the classpath
export JARCLASSPATH="$(find * -name *.jar | tr '\n' ':')"

tabpath="root/bdetab"
execpath="$EXECDIR/runPipeline.sh"
function usage {
	echo "Usage:"
	echo "$0 [scheduled]"
}

singleRunModes="newscrawl twittercrawl location cluster"
runscripts="(runNewsCrawling.sh runTwitterCrawling.sh runEventClustering.sh runLocationExtraction.sh  runPipeline.sh)"

if [ $# -eq  1 ] ; then
	# provided an argument
	if [ ! $1 == "scheduled" ] ; then
		# single run of a single component
		index=0
		for mode in "$singleRunModes"; do
			if [ "$mode" == "$1" ] ; then 
				bash "$EXECDIR/${runScripts[$index]}"
				echo "Completed."
				exit 0
			else
				index=$((index+1))
			fi
			>&2 echo "Undefined argument [$1]."
			usage
			exit 1
		done
		
		
		exit 1
	else
		# add the script call to a crontab
		echo "Scheduling job according to [$tabpath] :"
		if  [ ! -f $tabpath ] ; then
			>&2 echo "No crontab at $tabpath."
			exit 1
		fi
		cat $tabpath
		crontab $tabpath
	fi
elif [ $# -gt 1 ] ; then
	>&2 echo "$0 needs at most 1 argument."
	usage
	exit 1
else
	# no arguments provided : run whole pipeline once
	echo "Running an one-time instance."
	bash $EXECDIR/runPipeline.sh
	echo "Completed."
fi

