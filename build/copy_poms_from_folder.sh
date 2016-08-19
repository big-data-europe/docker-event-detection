#!/usr/bin/env bash  
folder="$1"
cp -v /$folder/base $BDE_ROOT_DIR/BDEEventDetection/BDEBase/pom.xml
cp -v /$folder/cluster $BDE_ROOT_DIR/BDEEventDetection/BDECLustering/pom.xml 
cp -v /$folder/location $BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/pom.xml
cp -v /$folder/news $BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/pom.xml
cp -v /$folder/twitter $BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/pom.xml 
cp -v /$folder/global $BDE_ROOT_DIR/BDEEventDetection/pom.xml 
