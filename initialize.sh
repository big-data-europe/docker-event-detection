#!/usr/bin/env bash

# Fix relative paths
####################



# properties files
newsprops="$BDEROOT/BDEEventDetection/BDERSSCrawler/res/newscrawler_configuration.properties";
sed -i "s<urls_file_name=.*<urls_file_name=$BDEROOT/BDEEventDetection/BDERSSCrawler/res/news_urls.txt<g" $newsprops

twitterprops="$BDEROOT/BDEEventDetection/BDETwitterListener/target/res/twitter.properties";


# initialize cassandra connections and twitter credentials
/connections_config.sh "$CONNECTIONS_FILE"

#echo "Running."
bash $EXECDIR/run.sh twittercrawl
bash