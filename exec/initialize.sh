#!/usr/bin/env bash

# Fix relative paths
####################
echo ;echo ">Running the BDE initialization script.($0)"; echo ;


# get and set properties files
##############################

# get potentially user supplied properties files
# or set the default deploy properties
echo "Fetching configuration property files for each BDE event detection module."
# news
newsprops="$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/news.properties";
if [ -f "$SUPPLIED_NEWS_PROPS_FILE" ]; then
	echo "Fetching user supplied news properties."
	cp "$SUPPLIED_NEWS_PROPS_FILE" "$newsprops"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/news.properties" "$newsprops"
fi

sed -i "s<urls_file_name=.*<urls_file_name=$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/news.urls<g" "$newsprops"
newsurls="$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/news.urls";
if [ -f "$SUPPLIED_NEWS_URLS_FILE" ]; then
	echo "Fetching user supplied news urls."
	cp "$SUPPLIED_NEWS_URLS_FILE" "$newsurls"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/news.urls" "$newsurls"
fi

# blogs
blogprops="$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/blogs.properties";
if [ -f "$SUPPLIED_BLOG_PROPS_FILE" ]; then
	echo "Fetching user supplied blog properties."
	cp "$SUPPLIED_BLOG_PROPS_FILE" "$blogprops"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/blogs.properties" "$blogprops"
fi

sed -i "s<urls_file_name=.*<urls_file_name=$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/blogs.urls<g" "$blogprops"
blogurls="$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/blogs.urls";
if [ -f "$SUPPLIED_BLOG_URLS_FILE" ]; then
	echo "Fetching user supplied blog urls."
	cp "$SUPPLIED_BLOG_URLS_FILE" "$blogurls"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/blogs.urls" "$blogurls"
fi

# clustering
############
clusterprops="$BDE_ROOT_DIR/BDEEventDetection/BDEClustering/res/clustering.properties";
if [ -f "$SUPPLIED_CLUSTER_PROPS_FILE" ]; then
	echo "Fetching user supplied clustering properties."
	cp "$SUPPLIED_CLUSTER_PROPS_FILE" "$clusterprops"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/clustering.properties" "$clusterprops"
fi
sed -i "s<sentence_splitter_model=.*<sentence_splitter_model=$BDE_ROOT_DIR/BDEEventDetection/BDEClustering/res/en-sent.bin<g" "$clusterprops"
sed -i "s<stopwords_file_path=.*<stopwords_file_path=$BDE_ROOT_DIR/BDEEventDetection/BDEClustering/res/stopwords_en.txt<g" "$clusterprops"

# location
##########
locationprops="$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/location.properties";
if [ -f "$SUPPLIED_LOCATION_PROPS_FILE" ]; then
	echo "Fetching user supplied location properties."
	cp "$SUPPLIED_LOCATION_PROPS_FILE" "$locationprops"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/location.properties" "$locationprops"
fi

# set hard paths
sed -i "s<ne_models_path=.*<ne_models_path=$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/ne_models<g" "$locationprops"
sed -i "s<sentence_splitter_model=.*<sentence_splitter_model=$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/en-sent.bin<g" "$locationprops"
sed -i "s<polygon_extraction_url=.*<polygon_extraction_url=http://teleios4.di.uoa.gr:8080/changeDetection/location/geocode<g" "$locationprops"
sed -i "s<polygon_extraction_impl=.*<polygon_extraction_impl=remote<g" "$locationprops"

# extractor 
locextractorprops="$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/locextractor.properties";
if [ -f "$SUPPLIED_LOCATION_EXTRACTOR_FILE" ]; then
        echo "Fetching user supplied location extractor."
        cp "$SUPPLIED_LOCATION_EXTRACTOR_FILE" "$locextractorprops"
else
    cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/locextractor.properties" "$locextractorprops"
fi

# check supplied restful extraction authentication var
if [ ! -z $EXTRACTOR_AUTH ]; then 
	echo "Setting location extractor authentication from docker-compose variable."
	sed -i "s/auth=/auth=$EXTRACTOR_AUTH/g" "$locextractorprops"
fi

# twitter

twitterprops="$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.properties"
if [ -f "$SUPPLIED_TWITTER_PROPS_FILE" ]; then
	echo "Fetching user supplied twitter properties."
	cp "$SUPPLIED_TWITTER_PROPS_FILE" "$twitterprops"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/twitter.properties" "$twitterprops"
fi
twitterqueries="$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.queries"
if [ -f "$SUPPLIED_TWITTER_QUERIES_FILE" ]; then
	echo "Fetching user supplied twitter queries."
	cp "$SUPPLIED_TWITTER_QUERIES_FILE" "$twitterqueries"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/twitter.queries" "$twitterqueries"
fi
twitteraccounts="$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.accounts"
if [ -f "$SUPPLIED_TWITTER_ACCOUNTS_FILE" ]; then
	echo "Fetching user supplied twitter accounts."
	cp "$SUPPLIED_TWITTER_ACCOUNTS_FILE" "$twitteraccounts"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/twitter.accounts" "$twitteraccounts"
fi


if [ -f "$SUPPLIED_TWITTER_RUNMODE_FILE" ]; then
	echo -n "Fetching user supplied twitter run mode :"
	twitterRunMode="$(cat $SUPPLIED_TWITTER_RUNMODE_FILE | head -1 | awk '{$1=$1;print}')"
	[ "$twitterRunMode" == "" ] && >&2 echo "Supplied empty twitter run mode file." && exit 1
	echo "$twitterRunMode"
	sed -i "s/operation_mode=.*/operation_mode=$twitterRunMode/g" "$twitterprops"
fi

sed -i "s<queries_source=.*<queries_source=$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.queries<g" "$twitterprops"
sed -i "s<accounts_source=.*<accounts_source=$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.accounts<g" "$twitterprops"




# set profiles path for language detection
profilesPath="$BDE_ROOT_DIR/BDEEventDetection/BDEBase/res/profiles"
[ ! -d "$profilesPath" ] && >&2 echo "Lang detection profiles do not exist at directory $profilesPath"
sed -i "s<lang_detection_profiles=.*<lang_detection_profiles=$profilesPath<g" "$newsprops"
sed -i "s<lang_detection_profiles=.*<lang_detection_profiles=$profilesPath<g" "$blogprops"
sed -i "s<lang_detection_profiles=.*<lang_detection_profiles=$profilesPath<g" "$twitterprops"
# initialize cassandra connections and twitter credentials. This is useful to quickly change host+port
# without supplying new properties files for each module
$EXEC_DIR/connections_config.sh

echo "It's done!" > "$INITIALIZATION_FILE"

echo "-Done running the BDE initialization script."; echo 

