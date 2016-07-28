#!/usr/bin/env bash

# Fix relative paths
####################



# properties files
newsprops="$BDEROOT/BDEEventDetection/BDERSSCrawler/res/newscrawler_configuration.properties";
sed -i "s<urls_file_name=.*<urls_file_name=$BDEROOT/BDEEventDetection/BDERSSCrawler/res/news_urls.txt<g" "$newsprops"

twitterprops="$BDEROOT/BDEEventDetection/BDETwitterListener/res/twitter.properties";

clusterprops="$BDEROOT/BDEEventDetection/BDECLustering/res/clustering.properties";
sed -i "s<sentence_splitter_model=.*<sentence_splitter_model=$BDEROOT/BDEEventDetection/BDECLustering/res/en-sent.bin<g" "$clusterprops"
sed -i "s<stopwords_file_path=.*<stopwords_file_path=$BDEROOT/BDEEventDetection/BDECLustering/res/stopwords_en.txt<g" "$clusterprops"

locationprops="$BDEROOT/BDEEventDetection/BDELocationExtraction/res/location_extraction.properties";
sed -i "s<ne_models_path=.*<ne_models_path=$BDEROOT/BDEEventDetection/BDELocationExtraction/res/ne_models<g" "$locationprops"
sed -i "s<sentence_splitter_model=.*<sentence_splitter_model=$BDEROOT/BDEEventDetection/BDELocationExtraction/res/en-sent.bin<g" "$locationprops"
#ne_models_path=./res/ne_models

# initialize cassandra connections and twitter credentials
/connections_config.sh "$CONNECTIONS_FILE"

#echo "Running."
bash $EXECDIR/run.sh location
bash