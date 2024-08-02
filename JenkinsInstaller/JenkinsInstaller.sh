#!/bin/bash


####################################
#
#Author : Dinesh 
#Date : 07.08.2024
#
#Description : Adding the repo and installing the  Jenkins Package 
#Version : 1
#
#####################################


#set -e 
#set -x

#variable for checking is repo added and package installed
isRepoAdded=$(find /etc/apt/sources.list.d/ -iname "jenkins.list")
isPkgInstalled=$( apt list --installed 2> /dev/null | grep -i "^jenkins/" ) # if none found throws exit code 1


if [ -z "$isRepoAdded" ] && [ -z "$isPkgInstalled" ];
then
    echo "Adding the Repo"
    #adding the GPG Key
   sudo wget -O /usr/share/keyrings/jenkins-keyring.asc  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
   #adding the Repository
   echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
 #updating the repo
   sudo apt-get update
   #installing the package
  sudo apt-get install jenkins -y
  echo "****** Jenkins Installed Successfully! ********"
elif  [ -n "$isRepoAdded" ] && [ -z "$isPkgInstalled" ]; then      	
       #updating the repo
        sudo apt-get update
       #installing the package
        sudo apt-get install jenkins -y
        echo "****** Jenkins Installed Successfully! ********"
else 
	echo " Jenkins is Already Installed. "
fi	

