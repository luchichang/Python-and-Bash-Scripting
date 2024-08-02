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




#Installing the Dependencies of Jenkins

echo "Before Installing Jenkins have you installed the Java package to the system"

sleep 2

read -p "enter [Y/N]: " InstallDep

if [ "$InstallDep" == "y" ] || [ "$InstallDep" == "Y" ];then
	sleep 

elif [ "$InstallDep" == "n" ] || [ "$InstallDep" == "N" ];then  
	echo "Installing the  Dependency Java  "
	sudo apt install default-jdk -y
else
	echo "             Bad Input exiting."
	exit 2
fi




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

