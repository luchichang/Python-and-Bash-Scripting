#!/bin/bash

#####################
#
#Version: 1.0.0
#Author: Dinesh
#
#Desc: montiors the System Resources such as CPU%, memory, Disk Usage.
#Date: 23.08.2024
#
######################

set -x

CPUStat=" $(iostat -c | grep -v "^$" |tail -n 1 ) "
UsrCPUUsage="$( echo $CPUStat  | awk '{print $1 }' ) "
SysCPUUsage="$( echo $CPUStat | awk '{ print $3 }' ) "
CPUThreshold=60.00


result="$( echo " ${UsrCPUUsage} > $CPUThreshold " | bc )"

if [ $result -eq 1 ];
then
	logger -p user.alert " ${USERNAME}'s CPU Usage is exceeding 60% kill unnecessary processes"
else
        logger -p user.info " ${USERNAME}'s Cpu Health is good"
fi



