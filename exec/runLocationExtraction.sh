#!/usr/bin/env bash
echo ">>>Running location extractor."

if [ -z $JARCLASSPATH ]; then
	bash $EXEC_DIR/setClassPath.sh
	JARCLASSPATH="$(cat $CLASSPATHFILE)"
fi

modulefolder="$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction"
locproperties="$modulefolder/res/location_extraction.properties"

execute="java -cp $JARCLASSPATH  gr.demokritos.iit.location.schedule.LocationExtraction $locproperties"
#echo "$execute"
logfile="$($EXEC_DIR/setLogfileName.sh location $LOG_DIR $LOG_PREFIX)"
echo "Writing log to $logfile"
$execute 2>&1 | tee  "$logfile"

echo "---Done running location extractor."
