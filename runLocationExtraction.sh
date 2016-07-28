#!/usr/bin/env bash
echo ">Running location extractor."

if [ -z $JARCLASSPATH ]; then
	bash $EXECDIR/setClassPath.sh
	JARCLASSPATH="$(cat $CLASSPATHFILE)"
fi

modulefolder="$BDEROOT/BDEEventDetection/BDELocationExtraction"
locproperties="$modulefolder/res/location_extraction.properties"

execute="java -cp $JARCLASSPATH  gr.demokritos.iit.location.schedule.LocationExtraction $locproperties"
#echo "$execute"
$execute
echo "-Done running location extractor."
