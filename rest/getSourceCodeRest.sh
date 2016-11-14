#!/usr/bin/env bash

echo "Getting source code of rest service. ($0)"
baseDestinationFolder="$1"
forceMode="$2"
sshfolder="$REST_SERVICES_DIR/sshauth"

tempDir=$baseDestinationFolder/temp
mkdir -p $tempDir


# check for valid ssh settings
if [ -d "$sshfolder" ]; then

	mkdir -p /root/.ssh && cp "$sshfolder/"* /root/.ssh/

	user="$(cat $sshfolder/config | grep User | cut -d' ' -f 2)"
	hostname="$(cat $sshfolder/config |  grep -G $'Host[ \t]' | cut -d' ' -f 2)"
	[ -z "$hostname" ] && >&2 echo "Host field was unset" && exit 1
	[ -z "$user" ] && >&2 echo "User field was unset" && exit 1
	echo "Fetching from local ssh repo:Reading [$sshfolder]"


	repoPathFile="$sshfolder/repoPath"
	! $REST_SERVICES_DIR/validatePath.sh  "$repoPathFile"  && exit 1
	repoPaths="$(cat $repoPathFile | awk '{$1=$1;print}')"
	cd $tempDir
	for p in $(echo $repoPaths); do
		command="git clone ${user}@${hostname}:$p"
		echo "Getting code with [$command]"
		$command
	done
else
	if [ "$forceMode" == "local" ]; then
		>&2 echo "Local repository acquisition failed."
		exit 1
	fi
	repoPathFile="$REST_SERVICES_DIR/repoPath"
	! $REST_SERVICES_DIR/validatePath.sh  "$repoPathFile"  && exit 1
	repoPaths="$(cat $repoPathFile | awk '{$1=$1;print}')"
	echo "No ssh folder found at [$sshfolder]. Reading repositories from [$repoPathFile]."

	cd $tempDir
	for p in $(echo $repoPaths); do
		echo "Fetching remote repo [$p]"
		git clone "$p" 
	done

	
fi

# move all rest services to $REST_SERVICES_DIR
mkdir -p /tmp/rest
mv $tempDir/* /tmp/rest
rm -rf $REST_SERVICES_DIR/*
mv /tmp/rest/* $REST_SERVICES_DIR

# install them
for p in $(ls $REST_SERVICES_DIR -1); do
	echo "Installing [$p]"
	direc="$REST_SERVICES_DIR/$p"
	cd $direc; 
	if [ -f "deps.sh" ]; then 
		sed -i 's/sudo //g' ./deps.sh
		./deps.sh; 
	fi
	if [ -f "install.sh" ]; then 
		sed -i 's/sudo //g' ./install.sh
		./install.sh; 
	fi
done

exit 0