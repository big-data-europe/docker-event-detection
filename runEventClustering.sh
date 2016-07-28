#!/usr/bin/env bash

echo ">Running event clusterer."

if [ -z $JARCLASSPATH ]; then
	bash $EXECDIR/setClassPath.sh
	JARCLASSPATH="$(cat $CLASSPATHFILE)"
fi

modulefolder="$BDEROOT/BDEEventDetection/BDECLustering"
configfile="$modulefolder/res/clustering.properties"


execute="java -cp $JARCLASSPATH  gr.demokritos.iit.clustering.exec.BDEEventDetection $configfile"
#echo "$execute"
$execute

echo "-Done running event clusterer."