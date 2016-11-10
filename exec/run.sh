#!/usr/bin/env bash

# script to run the BDE event detection pipeline
# first argument specified scheduled vs single run

echo ">Running BDE Event detection wrapper execution script at mode [$1]. ($0)"

singleRunModes="news tweets blogs location cluster pipeline"
runscripts=(runNewsCrawling.sh  runTwitterCrawling.sh runBlogCrawling.sh runLocationExtraction.sh runEventClustering.sh   runPipeline.sh)

function usage {
	echo "Module running usage:"
	echo -n "$0 [ $(echo $singleRunModes | sed 's/ / | /g') "
	echo "| init | cron | rest ]" # the init run mode is handled via the initialization script wrapper
	echo "(The argument is passed along from the driver script)"

}




if [ $# -gt  0 ] ; then
	# provided an argument
	if [ $1 == "help" ]; then
		usage;
		exit 0
	elif [ "$1" == "init" ]; then
		: # do nothing, it's already done
	elif [ "$1" == "cron" ] ; then
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
		cat "Submitted crontab [$SUPPLIED_CRONTAB_FILE]  at [$(date)]." >> "$LOG_DIR/cron.log"
		exit 0
	elif [ "$1" == "rest" ]; then
		# run rest service
		[ $# -lt 2 ] &&  >&2 echo "You need to provide the name of the rest service to run." && exit 1
		$EXEC_DIR/runREST.sh $2
		exit 1
	else
		# single run of a single component
		if [ -z $JARCLASSPATH ] &&  [ ! "$1" == "help" ] ; then
			bash $EXEC_DIR/setClassPath.sh $1
			export JARCLASSPATH="$(cat $CLASSPATHFILE)"
		fi
		index=0
		for mode in $singleRunModes; do
			arg=""
			if [ "$mode" == "$1" ] ; then 
				# run the script and exit
				bash "$EXEC_DIR/${runscripts[$index]}"
				exit 0
			else
				index=$((index+1))
			fi
		done
		>&2 echo "Undefined argument [$1]."
		usage
		exit 1	
	fi
else
	# no arguments provided : run whole pipeline once
	echo "Running an one-time instance."
	bash $EXEC_DIR/runPipeline.sh
	echo "Completed."
fi
echo "-Done running BDE Event detection wrapper execution script at mode [$1]."; echo
