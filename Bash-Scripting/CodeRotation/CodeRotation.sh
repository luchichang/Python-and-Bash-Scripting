#!/bin/bash

#set -x
set -e

#trap read debug

codeDirPath="$( echo $HOME )/web-tbs"
project='web'
dirName=''
liveCodePath="$( echo $HOME )/tbs-web-docker-compose"
backupPath="/Backups/${project}"
logFilePath="/var/log/CodeRotation.log"


# Logger Function
log() {
  local message="$1"
  local type="$2"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local color
  local endcolor="\033[0m"

  case "$type" in
    "info") color="\033[38;5;79m" ;;
    "success") color="\033[1;32m" ;;
    "error") color="\033[1;31m" ;;
    *) color="\033[1;34m" ;;
  esac

  echo -e "${color}${timestamp} - ${type}: ${message}${endcolor}" | tee -a $logFilePath 
}


# Strips and return Dir Name from the code dir path Global Variable
stripDirName () {
    # checking whether the path ends with /
    if [[ "$codeDirPath" =~ .*/$ ]]; then
        #triming the / at end
        codeDirPath="${codeDirPath%/}"
    fi
    # cut the end dir name
    echo $( echo $codeDirPath | rev | cut -d "/" -f 1 | rev ) 

}



checkNaming () {

dirName=$(stripDirName)

parentPath=$(dirname $codeDirPath)

  case $project in 
    'web')
        # prevents from renaming the existing directory
        test -d  $parentPath/WEB-TBS && { log "Directory already Exist" "error"; return 0; } || echo ":)"  
        if [[ "$dirName" != "WEB-TBS" ]]; then
            # updating the dir name to new
            dirName="WEB-TBS"
            mv $codeDirPath $parentPath/WEB-TBS && log "renamed Directory to compose file standard." "info"
            codeDirPath=$( echo ${parentPath}/${dirName})
        fi
        return 0
        ;;
    'api')
        # prevents from renaming the existing directory
        test -d  $parentPath/WEB-API-TBS && { log "Directory already Exist" "error"; return 0; } || echo ":)"  
        if [[ "$dirName" != "WEB-API-TBS" ]]; then
            dirName="WEB-API-TBS"
            mv $codeDirPath $parentPath/WEB-API-TBS && log "renamed Directory to compose file standard." "info"
            codeDirPath=$( echo ${parentPath}/${dirName})
        fi
        return 0
        ;;
    'crm-web')
        # prevents from renaming the existing directory
        test -d  $parentPath/CRM-TBS && { log "Directory already Exist" "error"; return 0; } || echo ":)"  
        if [[ "$dirName" != "CRM-TBS" ]]; then
            dirName="CRM-TBS"
            mv $codeDirPath $parentPath/CRM-TBS && log "renamed Directory to compose file standard." "info"
            codeDirPath=$( echo ${parentPath}/${dirName})
        fi
        return 0
        ;;
    'crm-api')
        # prevents from renaming the existing directory
        test -d  $parentPath/CRM-API-TBS && { log "Directory already Exist" "error"; return 0; } || echo ":)"  
        if [[ "$dirName" != "CRM-API-TBS" ]]; then
            dirName="CRM-API-TBS"
            mv $codeDirPath $parentPath/$dirName && log "renamed Directory to compose file standard." "info"
            codeDirPath=$( echo ${parentPath}/$dirName)
        fi
        return 0
        ;;
    *)
        log "Invalid Project Name" "error"
        return 1
        ;;
  esac

}


removeOldest () {
    # getting the individual directory name
    directories=($(ls -d ${backupPath}/${dirName}* ))
    dir1=${directories[0]}
    dir2=${directories[1]}
    dir3=${directories[2]}

    # finding the Oldest Directory
    oldestDir=$(test $dir1 -ot $dir2 && test $dir1 -ot $dir3 && echo $dir1 || (test $dir2 -ot $dir3 && echo $dir2 || echo $dir3))
    
    log "Oldest Directory is $oldestDir" "info"
    rm -ri  $oldestDir && log "removed Oldest Backup Dir PATH: $oldestDir" "success" || log "Failed Removing Dir." "error"


}

# Compress & Archives the N th code (i.e: current running live code)
cmpArchNthDir () {
    if [[ -d ${liveCodePath}/${dirName} ]]; then 
      tar -czvf ${dirName}-$(date +%s).tar.gz $dirName && log "Successfully compressed & archived $dirName" "success" || log "Failed Compressing & Archiving." "error"
      mv ${dirName}*.tar.gz ${backupPath}/ && log "moved compressed file to ${backupPath} Path" "success" || log "Failed Moving." "error"
      rm -rI $liveCodePath/${dirName} && log "Removing file in $liveCodePath" "info" || log "Failed Removing :("  "error"
    else 
      log "Directory ${dirName} doesn't exist in Path: ${liveCodePath}" "error"
    fi  
}

# Swap Updated Directory
swapUpdatedDir () {
    # checks the directory in the code path
    test ! -d $codeDirPath && { log "Code directory: $dirName is Missing in $(dirname $codeDirPath)" "error"; exit 1; }
    # test -d $liveCodePath 
    mv $codeDirPath $liveCodePath && log "successfully swapped the updated code to live code" "success" || log "Failed Moving :(" "error"

}

# Main Function
main () {

    # Checks the Dir name and rename it if wrong 
    checkNaming 

    #remove oldest Directory
    removeOldest

    # Compress & archive the live code
    cmpArchNthDir

    # Swaps the updated directory to the Live code path
    swapUpdatedDir

}

# Argument check
if [ $# -ge 1 ]; then 
    if [[ -d $1 ]]; then
      codeDirPath=$1
      log "Rotating live code with updated code in directory path: ${codeDirPath}" "info"
    else
       log "Invalid Dir path passed as an argument" "error"
       exit 1
    fi
else 
    log "Rotating the code for default argument Dir Path: ${codeDirPath} project: ${project}" "info"
fi

if [ $# -eq 2 ]; then
    backupPath=$(dirname $backupPath)
    if [ $2 = 'web' ]; then
      project='web'
      backupPath="${backupPath}/${project}"
      log "Rotating live code with updated code for project web" "info"
    elif [ $2 = 'api' ]; then
      project='api'
      backupPath="${backupPath}/${project}"
      log "Rotating live code with updated code for project api" "info"
    elif [ $2 = 'crm-web' ]; then
      project='crm-web'
      backupPath="${backupPath}/${project}"
      log "Rotating live code with updated code for project crm-web" "info"
    elif [ $2 = 'crm-api' ]; then
      project='crm-api'
      backupPath="${backupPath}/${project}" 
      log "Rotating live code with updated code for project crm-api" "info"
    else 
      log "Invalid Arguments" "error"
      exit 1
    fi
#else
 #   log "Rotating the code for default argument Dir Path: ${codeDirPath} project: ${project}" "info"
fi

# calling main function
if [[ -d $codeDirPath ]]; then 
    log "Starting the code rotation" "info"
    main
else 
    log "Invalid Directory Path." "error"
fi
 
