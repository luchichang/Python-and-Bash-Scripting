#!/bin/bash

# ==========================
#  DB SYNC CONFIGURATION
# ==========================

# FROM DB Credentials
fromDBServerHostName=""
fromDBServerPort=3306
fromDBName=""
fromDBServerUser=""
fromDBServerPassword=""

# TO DB Credentials
toDBServerHostName=""
toDBServerPort=3306
toDBName=""
toDBServerUser=""
toDBServerPassword="@3677"

# Mail Configuration
sendMailNotification=0
fromAddress=""
toAddress=""
mailSubject="DB Sync Notification"
mailBody="Database sync completed."

# MISC
logFilePath="/var/log/DBSync.log"
dumpDir="/var/backups/dbsync"
dumpFile="$dumpDir/${fromDBName}_$(date '+%Y%m%d_%H%M%S').sql"
maxFiles=5   # keep last 5 dumps
logFileDir=$(dirname ${logFilePath})


# ==========================
#  LOGGER FUNCTION
# ==========================
log() {
  local message="$1"
  local type="$2"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local color endcolor="\033[0m"

  case "$type" in
    "info") color="\033[38;5;79m" ;;
    "success") color="\033[1;32m" ;;
    "error") color="\033[1;31m" ;;
    *) color="\033[1;34m" ;;
  esac

  echo -e "${color}${timestamp} - ${type}: ${message}${endcolor}" | tee -a $logFilePath
}


# ==========================
#  MYSQL CONNECTION CHECK
# ==========================
mysqlConnectionCheck () {
    mysql -u "$1" -h "$2" -P "$3" -p"$4" "$5" -e '\q' 2>/dev/null

    if [ $? -eq 0 ]; then
        log "$6 MySQL Connection Successful" "success"
        return 1
    else
        log "$6 MySQL Connection Failed" "error"
        return 0
    fi
}


# ==========================
#  DATABASE DUMP
# ==========================
dbDump () {
    log "Starting dump of database $5…" "info"

    mysqldump -u "$1" -h "$2" -P "$3" -p"$4" --routines --triggers --events "$5" > "$dumpFile" 2>>$logFilePath

    if [ $? -eq 0 ]; then
        log "Dump created: $dumpFile" "success"
        return 1
    else
        log "Database dump failed!" "error"
        return 0
    fi
}


# ==========================
#  FILE ROTATION
# ==========================
fileRotation () {
    log "Performing dump file rotation…" "info"

    local fileCount=$(ls -1 $dumpDir/*.sql 2>/dev/null | wc -l)

    if [ "$fileCount" -gt "$maxFiles" ]; then
        local removeFiles=$(ls -1t $dumpDir/*.sql | tail -n +$(($maxFiles+1)))
        log "Removing old dump files…" "info"
        echo "$removeFiles" | xargs rm -f
    fi

    log "Dump file rotation completed." "success"
}


# ==========================
#  RESTORE DATABASE
# ==========================
restoreDatabase () {
    log "Restoring dump to destination database…" "info"

    mysql -u "$1" -h "$2" -P "$3" -p"$4" "$5" < "$dumpFile" 2>>$logFilePath

    if [ $? -eq 0 ]; then
        log "Database restored successfully." "success"
        return 1
    else
        log "Database restore failed!" "error"
        return 0
    fi
}


# ==========================
#  SEND MAIL
# ==========================
sendMail () {
    if [ "$sendMailNotification" -eq 1 ]; then
        echo "$mailBody" | mail -s "$mailSubject" -r "$fromAddress" "$toAddress"
        log "Mail notification sent." "info"
    fi
}


# ==========================
#  MAIN EXECUTION FLOW
# ==========================
main () {

    log "=== Starting Database Sync Process ===" "info"

    # 1) Sender Connection Check
    mysqlConnectionCheck "$fromDBServerUser" "$fromDBServerHostName" "$fromDBServerPort" "$fromDBServerPassword" "$fromDBName" "Sender"
    if [ $? -ne 1 ]; then exit 1; fi

    # 2) Receiver Connection Check
    mysqlConnectionCheck "$toDBServerUser" "$toDBServerHostName" "$toDBServerPort" "$toDBServerPassword" "$toDBName" "Receiver"
    if [ $? -ne 1 ]; then exit 1; fi

    # 3) Perform DB Dump
    dbDump "$fromDBServerUser" "$fromDBServerHostName" "$fromDBServerPort" "$fromDBServerPassword" "$fromDBName"
    if [ $? -ne 1 ]; then exit 1; fi

    # 4) File Rotation
    fileRotation

    # 5) Restore to Destination Server
    restoreDatabase "$toDBServerUser" "$toDBServerHostName" "$toDBServerPort" "$toDBServerPassword" "$toDBName"
    if [ $? -ne 1 ]; then exit 1; fi

    # 6) Email Notification
    sendMail

    log "=== Database Sync Completed Successfully ===" "success"
}

# Create log file directory if not exists
if [[ ! -d  ${logFileDir}  ]]; then
	mkdir -p  $logFileDir
	unset $logFileDir
else
	unset $logFileDir
fi

# Create log file if not exists
if [[ ! -e $logFilePath ]]; then
	touch $logFilePath
fi


# Create dumpDirectory if not exists
if [[ ! -d $dumpDir ]]; then
	log "creating dump directory ${dumpDir}" "info"
	mkdir -p "$dumpDir" && log "Dump Directory created successfully!" "success" || { log "Failed creating directory" "error"; return 0;}
fi


# Run only when no arguments
if [ $# -eq 0 ]; then
    main
else
    log "DataSync script expects no arguments" "error"
fi
