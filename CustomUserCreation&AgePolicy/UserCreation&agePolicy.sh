#!/bin/bash


#########################
#
#Author: Chang
#Date : 29.07.24
#
#Description: Creates the user according to the provided Values and Change its password policy
#version : 1
#
#########################

#set -x
set -e

#fetching the details 

read -p "Enter the Name of the User to be Created: " UName
read -p "Enter the User-Id of the  corresponding user (note: Should be <9000) : " UId
read -p "Enter the Group-Id of the  corresponding user (note: Should be <9000) : " GId
read -p "Enter the Comment for the  corresponding user: " Comment
read -p "Enter the  Shell of the  corresponding user (note: mention the Shell-Path): " ShellName



#making the Process running in the background 
#          sleep 1000 & #doesn't throw the error process is also not scheduled

#Creating the User
 sudo useradd -u $UId -s $ShellName  -c " $Comment " $UName #unable to update the groupId


for i in {1..3};
	do
		echo "*********Please Wait... Creating the User $UName ********"
                sleep 1
	done

	echo " "
	echo "             User $UName Created SuccessFully!!!!" 
        echo " " 
	echo " "

	echo " Enter the Details for changing the  ${UName}'s  Password Policy"


#Fetching the Details to change the password age of the User

read -p "Specify the Users Minimum Days to  Change Password : " MinDays 
read -p "Specify the Users Maximum Days to  Change Password : " MaxDays
read -p "Specify the Users No.of Days to Warn the Password Change : " WarningDays
read -p "Specify the Users In-Active Days After Password Change : " InactiveDays
read -p "Specify the Date to Expire the Password (note: Format YYY-MM-DD) : " ExpiryDate


#Changing the Users Password Policy

sudo chage -m $MinDays -M $MaxDays -W $WarningDays -E $ExpiryDate -I $InactiveDays  $UName

for i in {1..2};
	do
		echo "*********Please Wait... Conifguring the User ${UName}'s Password Policy  ********"
                sleep 1
	done

	echo " "
	echo " "

	echo "          SuccessFully Updated the ${UName}'s Password Policy!!!!"

	echo " "
	
