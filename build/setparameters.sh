#!.usr/bin/env bash 

# set hardcoded parameters
echo "Setting hardcoded parameters on source"
# set language detection source profiles folder
langDetectSrc="$BDE_ROOT_DIR/BDEEventDetection/BDEBase/src/main/java/gr/demokritos/iit/base/util/langdetect/CybozuLangDetect.java"
langProfiles="$BDE_ROOT_DIR/BDEEventDetection/BDEBase/res/profiles/"
if [ -z "$langDetectSrc" ]; then >&2 echo "Language detection class not found at $langDetectSrc"; exit 1; fi
sed -i "s<PROFILES_FILE_PROD =.*<PROFILES_FILE_PROD =\"$langProfiles\";<g" "$langDetectSrc" 
sed -i "s<PROFILES_FILE_DEV =.*<PROFILES_FILE_DEV =\"$langProfiles\";<g" "$langDetectSrc" 
echo "Updated language profiles sources."


sentSplitterSrc="$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/src/main/java/gr/demokritos/iit/location/extraction/provider/EnhancedOpenNLPTokenProvider.java"
neModels="/bde/BDEEventDetection/BDELocationExtraction/res/ne_models/"
sentSplitModel="/bde/BDEEventDetection/BDELocationExtraction/res/en-sent.bin"
if [ -z "$sentSplitterSrc" ]; then >&2 echo "EnhancedOpenNLPTokenProvider class not found at $sentSplitterSrc"; fi
sed -i "s<DEFAULT_NE_MODELS_PATH =.*<DEFAULT_NE_MODELS_PATH =\"$neModels\";<g" "$sentSplitterSrc"
sed -i "s<DEFAULT_SENT_SPLIT_MODEL_PATH =.*<DEFAULT_SENT_SPLIT_MODEL_PATH =\"$sentSplitModel\";<g" "$sentSplitterSrc"
echo "Updated sentence splitter source models."
