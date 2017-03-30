#!/usr/bin/env bash

# script to run the BDE event detection pipeline
# first argument specified scheduled vs single run

echo ">Running BDE Event detection wrapper execution script at mode [$1]. ($0)"

singleRunModes="news tweets blogs location cluster pipeline"
runscripts=(runNewsCrawling.sh  runTwitterCrawling.sh runBlogCrawling.sh runLocationExtraction.sh runEventClustering.sh   runPipeline.sh)

function moduleusage {
	echo 
	echo "Module running usage:"
	echo "----------------------------------- "
	echo -n "/driver.sh [ $(echo $singleRunModes | sed 's/ / | /g') "
	echo "| init | cron | rest <restname> ]" # the init run mode is handled via the initialization script wrapper
	echo "Availabe rest services:"
	echo "[$(ls $REST_SERVICES_DIR)]"
	echo
}

function info {
	echo
	echo
	echo "Container important directories:"
	echo "---------------------------------- "
	echo "BDE sourcesfolder [$BDE_ROOT_DIR]."
	echo "REST services sources folder [$REST_SERVICES_DIR]."
	echo "Daemon folder [$DAEMON_DIRECTORY]."
	echo "Logs folder [$LOG_DIR]."
	echo "Mount folder [$MOUNT_DIR]."
	echo
	echo "User-provided module parameters:"
	echo "Connections auth folder [$CONNECTIONS_CONFIG_FOLDER]. See connections_config.sh for details"
	echo "news properties [$SUPPLIED_NEWS_PROPS_FILE]"
	echo "news urls [$SUPPLIED_NEWS_URLS_FILE]"
	echo "clustering properties [$SUPPLIED_CLUSTER_PROPS_FILE]"
	echo "location properties [$SUPPLIED_LOCATION_PROPS_FILE]"
	echo "twitter queries [$SUPPLIED_TWITTER_QUERIES_FILE]"
	echo "twitter properties [$SUPPLIED_TWITTER_PROPS_FILE]" 
	echo "twitter accounts [$SUPPLIED_TWITTER_ACCOUNTS_FILE]" 
	echo "blogs properties [$SUPPLIED_BLOG_PROPS_FILE]"
	echo "blogs urls [$SUPPLIED_BLOG_URLS_FILE]"
	echo "bde crontab [$SUPPLIED_CRONTAB_FILE]"
	
	echo
}



if [ $# -gt  0 ] ; then
	# provided an argument
	if [ $1 == "help" ]; then
		moduleusage;
		info;
		exit 0
	elif [ "$1" == "init" ]; then
		# It was explicitly asked to initialize, not as a part of a task. Won't notify daemon.
		# Also this explicit initialization overwrites existing ones
		"$EXEC_DIR/runInitialization.sh" "init"
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
		exit 0
	else
		# single run of a single component

		index=0
		for mode in $singleRunModes; do
			arg=""
			if [ "$mode" == "$1" ] ; then 
				# set the class path if not already set
				if [ -z $JARCLASSPATH ] &&  [ ! "$1" == "help" ] ; then
					bash $EXEC_DIR/setClassPath.sh $1
					export JARCLASSPATH="$(cat $CLASSPATHFILE)"
				fi
				# run the script and exit
				"$DAEMON_DIRECTORY/daemonInterface.sh" "init" "$mode" 
				"$EXEC_DIR/runInitialization.sh"
				"$DAEMON_DIRECTORY/daemonInterface.sh" "exec" "$mode" 
				"$EXEC_DIR/${runscripts[$index]}"
				"$DAEMON_DIRECTORY/daemonInterface.sh" "finish" "$mode" 
				exit 0
			else
				index=$((index+1))
			fi
		done
		>&2 echo "Undefined argument [$1]."
		moduleusage
		exit 1	
	fi
else
	# no arguments provided : run whole pipeline once
	echo "Running an one-time instance."
	bash $EXEC_DIR/runPipeline.sh
	echo "Completed."
fi
echo "-Done running BDE Event detection wrapper execution script at mode [$1]."; echo
