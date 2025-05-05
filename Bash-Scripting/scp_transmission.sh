#!/bin/sh

#Array of User Name
declare -a uName=(
[0]=tony
[1]=steve
[2]=banner
[3]=peter
)

# Array of User Password
declare -a uPass=(
[0]=Ir0nM@n
[1]=Am3ric@
[2]=BigGr33n
[3]=Sp!dy
)

# Array of Host IP
declare -a hostIP=(
[0]=172.16.238.10
[1]=172.16.238.11
[2]=172.16.238.12
[3]=172.16.239.10
)

srcPath=/home/thor/nautilus_banner
destPath=~/

for (( i=0; i<${#uName[@]}; i++ ));
do
  sshpass -p ${uPass[$i]} scp -o StrictHostKeyChecking=no src ${uName[$i]}@${hostIP[$i]}:~/
  if [ $? -eq 0 ]; then
    echo "FIle Transferred Successfully!"
  fi
done