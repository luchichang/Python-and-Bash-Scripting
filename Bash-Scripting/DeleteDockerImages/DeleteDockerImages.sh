#!/bin/bash

##################
#
#Date: 01.09.2024
#Author: Dinesh
#
#Desc: Deletes all the docker Images
#Version: 1
#
###################

set -e 
set -o pipefail

lineCount=$( docker images | wc -l ) 
imageCount=$((lineCount - 1)) 

# Special CASE
if [ "$imageCount" == "0" ];
then
    echo " No Images to Delete."
    exit 0
fi


echo "Are you sure you wanna delete all the $imageCount Images"

read -p "Enter y/n:" usrChoice

if [ "$usrChoice" == "n" ] || [ "$usrChoice" == "N" ];then
    echo "Exiting"
    exit 0
elif [ "$usrChoice" == "y" ] || [ "$usrChoice" == "Y" ];then
      
       #storing the image list	
       docker images | tail -n $imageCount | awk '{print $3}' > imgIdList.txt
       #extracting the text file into array
       mapfile imgIdList < imgIdList.txt
     for imgId in ${imgIdList[@]};
     do
               
       	echo "deleting the ${imgId} docker image"
      	     docker rmi -f $imgId
     done

     #freeing up the 
      rm -rf imgIdList.txt
      unset imgIdList
else
     echo " Bad Input! Exiting."
     exit 2
fi



