
#!/usr/bin/env bash

echo ">>>Running event clusterer. ($0)"

if [ -z $JARCLASSPATH ]; then
	bash $EXEC_DIR/setClassPath.sh
	JARCLASSPATH="$(cat $CLASSPATHFILE)"
fi

modulefolder="$BDE_ROOT_DIR/BDEEventDetection/BDECLustering"
configfile="$modulefolder/res/clustering.properties"


execute="java -cp $JARCLASSPATH  gr.demokritos.iit.clustering.exec.BDEEventDetection $configfile strabon"
#echo "$execute"
logfile="$($EXEC_DIR/setLogfileName.sh cluster $LOG_DIR $LOG_PREFIX)"
echo "Writing log to $logfile"
$execute 2>&1 | tee  "$logfile"

echo "---Done running event clusterer."
