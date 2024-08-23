#!/bin/bash

####################
#
#Date: 26.08.2024
#Author: Dinesh
#
#Desc: Searches for the user provided keyword in the log file
#Version: 1.0.0
#
###################

#set -x
set -e

#declaring the array of files
fileNames=("messages" "secure" "maillog" "cron" "boot-log")

#user Prompt
echo -e  "press corresponding number to search the keywrod in the log file for,\n \n" 

#variable for incrementing 
num=1

for i in ${fileNames[@]};
do
	echo " $num $i"
	#incrementing the value
	num=$(( num + 1 ))
done

#cleaning the Variable
unset num 

echo -e "\n"

read -p  "enter: " usrChoice

#error handling
#if [[ $usrChoice <1 ]] || [[ $usrChoice > 5 ]];
if [[ ! "$usrChoice" =~ ^[1-5]$ ]];
then
	echo " Bad Input! Exiting."
	exit 1
fi


#storing the file Path
filePath="/var/log/${fileNames[$((usrChoice - 1 ))]}"

read -p  "Enter the Keyword/reg-ex to search for in the Path $filePath : " keyWord


#storing the count 
matchCount="$( sudo grep -c "$keyWord" "$filePath" 2>/dev/null || echo "0" ) "


# Case Handling
if [[ $matchCount -eq 0 ]];
then
	echo "                         No Matches Found!"
        exit 1
else

        echo "                        Displaying the $matchCount founded matches. "

        #searching the text and displaying it
        sudo cat "$filePath" | grep -i "$keyWord"  
fi


