#!/usr/bin/env bash

###########################################################################################################
echo "P E A R S O N   updateITunes   S C R I P T   V.1.5" >> /.pss_logs/updateITunes.log
###########################################################################################################

## this script runs from casper to update iTunes on the client
## NOTE: use find and replace function in TextEdit to replace updateITunes with the new script name


###########################################################################################################
#####################         V E R S I O N    C O N T R O L             ##################################
###########################################################################################################

## Chris Hopkins - originating author at version 1.0 - 10 02 2011

## V.1.5 - Added fix for osascript call and more explicit variables - Chris Hopkins - 02 06 2014
## V.1.4 - Added bubble notification and report on the version installed - Chris Hopkins - 14 11 2013
## V.1.3 - Fixed to get only recent update using head command - Chris Hopkins - 18 07 2013
## V.1.2 - Set softwareupdate command to not work in background - Chris Hopkins - 19 09 2012
## V.1.1 - Set softwareupdate command to work in background - Chris Hopkins - 18 02 2011


###########################################################################################################
#####################             S C R I P T   S T A R T                ##################################
###########################################################################################################

## we generate a timestamp for later use
timestamp="$(date "+%d.%m.%y at %H.%M")"

## create pss logs folder at root of startup disk to put log files in
mkdir -p /.pss_logs

## Timestamp the updateITunes.log file
echo ran by: "$USER" at "$timestamp" >> /.pss_logs/updateITunes.log

## Declare CocoaDialog calls
CD=/Library/Application\ Support/Pearson/cocoaDialog.app/Contents/MacOS/cocoaDialog

## Kill iTunes
iTunesRunning=`ps auxc | grep -v grep | grep iTunes | grep -v iTunesHelper | awk '{print $11}'`
iTunesMessage="iTunes will now be quit for an update"
if test "$iTunesRunning" = "iTunes"
   then
     arch -i386 osascript -e 'tell application "Finder"' -e 'Activate' -e "display dialog \"$iTunesMessage\"" -e 'end tell' giving up after 6
     arch -i386 osascript -e 'tell application "iTunes" to quit'
     wait
fi

sleep 5

## get name of iTunes update
itunesInstaller=$(softwareupdate -l | grep iTunesX | awk '{print $2}' | head -1)
echo installer to run is "$itunesInstaller" >> /.pss_logs/updateITunes.log
if test "$itunesInstaller" = ""
	then
		echo no update for iTunes found so quitting here >> /.pss_logs/updateITunes.log
		exit
fi

## perform specific update
softwareupdate -i "$itunesInstaller"

wait

## Get version of iTunes
iTunesVersion=`echo "$itunesInstaller" | tr -d [:alpha:] | sed 's|[-]||g'`

## Notify the user as to completion and version installed
"$CD" bubble --debug --titles "Finished" --text-colors "0c1c8c" --texts "Your iTunes upgrade is now complete with version "$iTunesVersion"" --background-tops "00cb24" --background-bottoms "aefe95" --border-colors "2100b4" "a25f0a" --icons "Info" --no-timeout

echo " " >> /.pss_logs/updateITunes.log
echo finished script at "$timestamp" >> /.pss_logs/updateITunes.log
echo " " >> /.pss_logs/updateITunes.log
echo ------------------------------------------------------------------------------------------ >> /.pss_logs/updateITunes.log
echo " " >> /.pss_logs/updateITunes.log

exit 0
