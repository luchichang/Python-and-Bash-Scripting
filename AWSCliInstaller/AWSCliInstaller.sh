#!/bin/bash

#############
#
#Author: Dinesh
#Version: 1.0.0
#
#Desc: adding the repo & installing the aws cli
#Date: 04.09.2024
#
##############

set -e

#variable declaration
isAWSInstalled=$( aws --version > /dev/null 2>&1 ; echo $?) 
isUnZipInstalled=$( unzip --version  >/dev/null 2>&1 ; echo $?)

#if Exit code == 127, then pkg is not installed. if Exit code 0, pkg is installed  


#condition Check
if [[ "$isAWSInstalled" -eq "0" ]]; 
then
	echo "AWS-cli is Already Installed!"
else
	if [[ "$isUnZipInstalled" -ne "0" ]];then
        	sudo apt update && sudo apt install unzip -y
	fi
        echo "                     Installing the AWS CLI....."	
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
        echo "                     AWS CLI Installed Successfully!"	
       #cleanup Process
        rm -rf awscliv2* ^aws$
fi

