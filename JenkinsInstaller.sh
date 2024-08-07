#!/bin/bash

set -e 
set -o



Installer(){
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
}


#main Script

isInstalled=`sudo apt list --installed | grep -i "^jenkins" 2>/dev/null`
if [ -z $isInstalled ]
then 
	echo "Installing the Jenkin Package"
        Installer &>/dev/nul
        echo "Jenkins Package get installed Successfully"
else
	echo "Jenkin is Already Installed!!"
fi


