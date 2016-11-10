#!/usr/bin/env bash

# for automation
#for restServ in $(ls $REST_SERVICES_DIR); do
#	restFolder="$REST_SERVICES_DIR/$restServ"

cd "$REST_SERVICES_DIR"
git clone https://github.com/npit/twitterRest
cd twitterRest && ./install.sh
