#!/usr/bin/env bash

echo "Getting source code. ($0)"
destinationFolder="$1"
forceMode="$2"
sshfolder="/build/sshauth"


# check for valid ssh settings
if [ -d "$sshfolder" ]; then
	repoPathFile="$sshfolder/repoPath"
	! /build/validatePath.sh  "$repoPathFile"  && exit 1
	repoPath="$(cat $repoPathFile | head -1 | awk '{$1=$1;print}')"
	branch="$(cat $repoPathFile | head -2 | tail -1 | awk '{$1=$1;print}')"
	>&2 echo "Using branch [$branch] from local repository."
	echo "$branch" > /branchname
	echo "Fetching from local ssh repo:Reading [$sshfolder]"
	mkdir /root/.ssh && cp "$sshfolder/"* /root/.ssh/

	user="$(cat $sshfolder/config | grep User | cut -d' ' -f 2)"
	hostname="$(cat $sshfolder/config |  grep -G $'Host[ \t]' | cut -d' ' -f 2)"
	command="git clone ${user}@${hostname}:$repoPath $destinationFolder"
	[ -z "$hostname" ] && >&2 echo "Host field was unset" && exit 1
	[ -z "$user" ] && >&2 echo "User field was unset" && exit 1
	echo "Getting code with [$command]"
	$command
else
	if [ "$forceMode" == "local" ]; then
		>&2 echo "Local repository acquisition failed."
		exit 1
	fi
	repoPathFile="/build/repoPath"
	! /build/validatePath.sh  "$repoPathFile"  && exit 1
	repoPath="$(cat $repoPathFile | head -1 | awk '{$1=$1;print}')"
	branch="$(cat $repoPathFile | head -2 | tail -1 | awk '{$1=$1;print}')"
	>&2 echo "Using branch [$branch] from remote repository."
	echo "$branch" > /branchname
	echo "No ssh folder found at [$sshfolder], fetching from the web repo: [$repoPath]"
	


	git clone "$repoPath" "$destinationFolder"
fi
