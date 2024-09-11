#! /bin/bash 

##################
##
#Author : Dinesh 
#Description : remove all the files and folder expect the default skel files
#
############


set -e 
#set -x

#Script File Names 
ScriptName="DeleteallFiles.sh"

#getting the executers current path 
EPath=$(pwd)

echo -e " note: executing this Script will delete all the visible files and Folder in the Path $EPath  \n use it safely"

read -p "Do you wanna Delete all the files & folders [Y/N]:" UsrChoice

if [ "$UsrChoice" == "Y" ] || [ "$UsrChoice" == "y"  ];
then
#getting the files and folders and storing it in the FilesList
echo " $(ls "$EPath" )" > FilesListtmp.txt

#getting the Array from the files
mapfile fileNames <  FilesListtmp.txt



#looping through the list and removing the file 
for FName in ${fileNames[@]}
do
	if [ $ScriptName != $FName ]
       	then
	  rm -rf $FName
	fi
done

#removing the Tmp file
rm -f FilesListtmp.txt

echo " All the Files & Folders are Deleted Successfully!"

else 
	echo "Exiting!!!!!"
fi



