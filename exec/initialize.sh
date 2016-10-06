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
newsprops="$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/newscrawler_configuration.properties";
if [ -f "$SUPPLIED_NEWS_PROPS_FILE" ]; then
	echo "Fetching user supplied news properties."
	cp "$SUPPLIED_NEWS_PROPS_FILE" "$newsprops"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/newscrawler_configuration.properties" "$newsprops"
fi

sed -i "s<urls_file_name=.*<urls_file_name=$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/news_urls.txt<g" "$newsprops"
newsurls="$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/news_urls.txt";
if [ -f "$SUPPLIED_NEWS_URLS_FILE" ]; then
	echo "Fetching user supplied news urls."
	cp "$SUPPLIED_NEWS_URLS_FILE" "$newsurls"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/news_urls.txt" "$newsurls"
fi

# blogs
blogprops="$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/blogcrawler_configuration.properties";
if [ -f "$SUPPLIED_BLOG_PROPS_FILE" ]; then
	echo "Fetching user supplied blog properties."
	cp "$SUPPLIED_BLOG_PROPS_FILE" "$blogprops"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/blogcrawler_configuration.properties" "$blogprops"
fi

sed -i "s<urls_file_name=.*<urls_file_name=$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/blog_urls.txt<g" "$blogprops"
blogurls="$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/blog_urls.txt";
if [ -f "$SUPPLIED_BLOG_URLS_FILE" ]; then
	echo "Fetching user supplied blog urls."
	cp "$SUPPLIED_BLOG_URLS_FILE" "$blogurls"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/blog_urls.txt" "$blogurls"
fi

# clustering
clusterprops="$BDE_ROOT_DIR/BDEEventDetection/BDECLustering/res/clustering.properties";
if [ -f "$SUPPLIED_CLUSTER_PROPS_FILE" ]; then
	echo "Fetching user supplied twitter properties."
	cp "$SUPPLIED_CLUSTER_PROPS_FILE" "$clusterprops"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/clustering.properties" "$clusterprops"
fi
sed -i "s<sentence_splitter_model=.*<sentence_splitter_model=$BDE_ROOT_DIR/BDEEventDetection/BDECLustering/res/en-sent.bin<g" "$clusterprops"
sed -i "s<stopwords_file_path=.*<stopwords_file_path=$BDE_ROOT_DIR/BDEEventDetection/BDECLustering/res/stopwords_en.txt<g" "$clusterprops"

# location
##########
locationprops="$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/location_extraction.properties";
if [ -f "$SUPPLIED_LOCATION_PROPS_FILE" ]; then
	echo "Fetching user supplied location properties."
	cp "$SUPPLIED_LOCATION_PROPS_FILE" "$locationprops"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/location_extraction.properties" "$locationprops"
fi
# set hard paths
sed -i "s<ne_models_path=.*<ne_models_path=$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/ne_models<g" "$locationprops"
sed -i "s<sentence_splitter_model=.*<sentence_splitter_model=$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/en-sent.bin<g" "$locationprops"
sed -i "s<polygon_extraction_url=.*<polygon_extraction_url=http://teleios4.di.uoa.gr:8080/changeDetection/location/geocode<g" "$locationprops"
#sed -i "s<polygon_extraction_impl=.*<polygon_extraction_impl=local<g" "$locationprops"
#sed -i "s<polygon_extraction_impl=.*<polygon_extraction_impl=remote<g" "$locationprops"

# unzip the local location extraction dataset 
mkdir -p "$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/local/"

unzip -q "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/dataset.zip" -d "$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/local/"
mv $BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/local/*  "$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/local/dataset.csv"
sed -i "s<polygon_extraction_sourcefile=.*<polygon_extraction_sourcefile=$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/local/dataset.csv<g" "$locationprops"


twitterqueries="$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.queries"
if [ -f "$SUPPLIED_TWITTER_QUERIES_FILE" ]; then
	echo "Fetching user supplied twitter queries."
	cp "$SUPPLIED_TWITTER_QUERIES_FILE" "$twitterqueries"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/twitter.queries" "$twitterqueries"
fi
twitterprops="$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.properties"
if [ -f "$SUPPLIED_TWITTER_PROPS_FILE" ]; then
	echo "Fetching user supplied twitter properties."
	cp "$SUPPLIED_TWITTER_PROPS_FILE" "$twitterprops"
else
	cp "$BDE_ROOT_DIR/BDEEventDetection/skel_property_files/twitter.properties" "$twitterprops"
fi

# set profiles path for language detection
profilesPath="$BDE_ROOT_DIR/BDEEventDetection/BDEBase/res/profiles"
[ ! -d "$profilesPath" ] && >&2 echo "Lang detection profiles do not exist at directory $profilesPath"
sed -i "s<lang_detection_profiles=.*<lang_detection_profiles=$profilesPath<g" "$newsprops"
sed -i "s<lang_detection_profiles=.*<lang_detection_profiles=$profilesPath<g" "$blogprops"
sed -i "s<lang_detection_profiles=.*<lang_detection_profiles=$profilesPath<g" "$twitterprops"
# initialize cassandra connections and twitter credentials. This is useful to quickly change host+port
# without supplying new properties files for each module
$EXEC_DIR/connections_config.sh "$CONNECTIONS_CONFIG_FILENAME" 

echo "It's done!" > "$INITIALIZATION_FILE"

echo "-Done running the BDE initialization script."; echo 

