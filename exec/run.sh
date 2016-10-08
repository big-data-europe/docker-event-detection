#!/usr/bin/env bash

# script to run the BDE event detection pipeline
# first argument specified scheduled vs single run

echo ">Running BDE Event detection wrapper execution script at mode [$1]. ($0)"

singleRunModes="news tweets-search tweets-monitor tweets-stream blogs location cluster pipeline"
runscripts=(runNewsCrawling.sh runTwitterCrawling.sh runTwitterCrawling.sh  runTwitterCrawling.sh runBlogCrawling.sh runLocationExtraction.sh runEventClustering.sh   runPipeline.sh)

function usage {
	echo "Module running usage:"
	echo -n "$0 [ $(echo $singleRunModes | sed 's/ / | /g') "
	echo "| cron | ]"
	echo "(The argument is passed along from the driver script)"

}

if [ -z $JARCLASSPATH ] &&  [ ! "$1" == "help" ] ; then
		bash $EXEC_DIR/setClassPath.sh $1
	export JARCLASSPATH="$(cat $CLASSPATHFILE)"
fi


if [ $# -eq  1 ] ; then
	# provided an argument
	if [ $1 == "help" ]; then
		usage;
		exit 0
	fi
	if [ ! $1 == "cron" ] ; then
		# single run of a single component
		index=0
		for mode in $singleRunModes; do
			arg=""
			if [ "$mode" == "$1" ] ; then 
				# specify twitter run mode
				if [ ! -z "$( echo $mode | grep tweets)" ]; then
					echo -n "Twitter crawler mode : "
	                                if [ ! -z "$( echo $mode | grep  search)" ]; then
                                		arg="search"
					elif [ ! -z "$(echo $mode | grep  monitor)" ]; then
                                                arg="monitor"
					elif [ ! -z "$(echo $mode | grep  stream)" ]; then
                                                arg="stream"
					fi
					echo "[$arg]"
				fi
				# run the script and exit
				bash "$EXEC_DIR/${runscripts[$index]}" "$arg"
				exit 0
			else
				index=$((index+1))
			fi
		done
		>&2 echo "Undefined argument [$1]."
		usage
		exit 1

	else
		# cronjob run
		echo "Scheduling job according to crontab at [$SUPPLIED_CRONTAB_FILE]."
		
		if  [ ! -f $SUPPLIED_CRONTAB_FILE ] ; then
			>&2 echo "No crontab at $SUPPLIED_CRONTAB_FILE."
			exit 1
		fi
		echo  "Crontab contents are:"
		echo
		cat "$SUPPLIED_CRONTAB_FILE"
		echo
		echo "Note: make sure the script invoked is executable."
		echo  "Starting & scheduling."
		# start cron, register the tab and exit.
		service cron start
		crontab $SUPPLIED_CRONTAB_FILE
		cat "Submitted crontab [$SUPPLIED_CRONTAB_FILE]  at [$date]." >> "$LOG_DIR/cron.log"
		exit 0
	fi
elif [ $# -gt 1 ] ; then
	>&2 echo "$0 needs at most 1 argument."
	usage
	exit 1
else
	# no arguments provided : run whole pipeline once
	echo "Running an one-time instance."
	bash $EXEC_DIR/runPipeline.sh
	echo "Completed."
fi
echo "-Done running BDE Event detection wrapper execution script at mode [$1]."; echo
