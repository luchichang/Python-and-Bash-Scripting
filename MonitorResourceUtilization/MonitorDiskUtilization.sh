#!/bin/bash

#####################
#
#Date: 25.08.2024
#Author: Dinesh
#
#Desc: Monitors the Disk Utilization continously
#Version: 0.0.1
#
#######################

set -x

freeMem=" $( free -b | grep -i "^mem" | awk '{ print $4 } ') "
totalMem=" $( free -b | grep -i "^mem" | awk ' {print $2 } ' ) "

#handling the Float point numbers 

MemThreshold=" $( echo " scale=2; $totalMem / 4.0 " | bc ) "

# comparing the distance 
result=" $( echo " $freeMem < $MemThreshold " | bc ) "

if [ $result ];
then
	logger -p user.alert " System's Disk usage is almost full"
else
	logger -p user.info " System's Disk usage is working fine"
fi


