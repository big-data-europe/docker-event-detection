#!/usr/bin/env bash

echo ">Running event clusterer."

modulefolder="$BDEROOT/BDEEventDetection/BDECLustering"
configfile="$modulefolder/res/clustering.properties"


java -cp "$JARCLASSPATH"  gr.demokritos.iit.clustering.exec.BDEEventDetection "$configfile"
echo "-Done running event clusterer."