#!/bin/bash

########################
#
#Author : Dinesh
#Date : 31-07-2024
#
#Description : Multiple Package installer 
#Version : 1
#
#######################


##################################
# COMPLEXITY ANALYSIS
#
# TIME  Complexity :
# Space Complexity :
#
###################################
set -x
set -e 
set -o pipefail 


# prompting the Package Count
read -p "Enter the Package Count : " pkgCount

if [[ $pkgCount -lt 1 ]];
then
	echo "                  Package Count must be Positive Number"
        exit 1
fi



# Package  array
for i in {0..100};
do
	if [[ i -eq  $pkgCount ]];
	then
		break
	fi

        #user Prompt 
	read -p "Enter the $((i+1)) Package Name : " PkgName
	packages[$i]=$PkgName
done

#echo " package List : ${packages[@]} "


 #Array Idx
   IPIdx=0
   AIIdx=0
   PNEIdx=0

for pkg in ${packages[@]};
do


  # storing the pkg Info and Nullifying the error

   #PkgInfo=` dnf info $PkgName 2 > /dev/null `


 #Validating the Packages 
         isInstalled=` dnf info $pkg 2> /dev/null | grep -i "^Installed Packages"`
         isAvailable=` dnf info $pkg 2> /dev/null | grep -i "^Available Packages"`


	 if [[ -z $isInstalled ]] && [[ -z $isAvailable ]] ;
	 then 
                 echo -e " \n         Package $pkg does'nt exist" 
		# read -p " kindly re-enter the correct  Package Name : " PName
		PkgNameErr[PNEIdx++]=$pkg
	 elif [[ -n $isInstalled ]];
	 then
		 echo -e " \n        $pkg Package is Already Installed.. \n\n"
                 sleep 3
		 AIPkg[$((AIIdx++))]=$pkg

	 else 
                   for j in {1..3};
		   do
		 echo -e " \n         $pkg Package is to be automatically Installed within $j seconds \n"
		 sleep 1
	 done
	 echo -e " **********Installing the package $pkg*********** \n "
	 sleep 1
		sudo dnf install $pkg -y 2>/dev/null
		 IPkg[$((IPIdx++))]=$pkg
		 echo -e "\n\n        $pkg Installed Successfully!!! \n"
	         sleep 3
	 fi


 done


 echo "-----------------------------------------------------------------------------"
 echo -e "\n                        Package Installer summary                  "
 echo -e "\n Entered Packages : ${packages[@]}\n "


# echo -e " Installed Packages : $(( ${#IPkg[@]} == "0" ? "NIL" : "${IPkg[@]}" )) \n "  Ternary Operator is not working


        if [[ ${#IPkg[@]} -eq 0 ]];
	then
		echo -e " Installed Packages : NIL \n "
	fi

        if [[ ${#IPkg[@]} -gt 0 ]];
	then
		echo -e " Installed Packages : ${IPkg[@]}\n "
	fi

	 if [[ ${#AIPkg[@]} -gt 0 ]];
	 then
	    echo -e " Already Installed Packages : ${AIPkg[@]} \n "
	 fi


	 if [[ ${#AIPkg[@]} -eq 0 ]];
	 then
	    echo -e " Already Installed Packages : NIL \n "
	 fi
	 if [[ ${#PkgNameErr[@]} -gt 0 ]];
	 then 
		echo -e " Package Name Error : ${PkgNameErr[@]} "
	 fi	
echo "------------------------------------------------------------------------------"
