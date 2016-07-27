#!/usr/bin/env bash
echo ">Running location extractor."

modulefolder="$BDEROOT/BDEEventDetection/BDELocationExtraction"

locproperties="$modulefolder/res/location_extraction.properties"

java -cp "$JARCLASSPATH"  gr.demokritos.iit.location.schedule.LocationExtraction "$locproperties"
echo "-Done running location extractor."
