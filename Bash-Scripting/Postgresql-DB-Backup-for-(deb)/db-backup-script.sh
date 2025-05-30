#!/bin/bash


#################
#
## Author: Dinesh T
## Date: 06.02.2025
#
## Description: Script for DB backup
## Version: 1
#
#################

set -e

log() {
	local message=$1
	local type=$2
	local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
	local color
	local endcolor="\033[0m"

	case "$type" in 
		"info") color="\033[38;5;79m" ;;
		"success") color="\033[1;32m" ;;
		"error") color="\033[1;31m" ;;
		*) color="\033[1;34m" ;;
	esac

	echo -e "${color}${timestamp} - ${type}: ${message}${endcolor}" > ~/db-backup/$(date +%m_%d_%y)/$(date +%m_%d_%y).log
}

handle_error() {
	local exit_code=$1
	local error_message="$2"
	log "$error_message (Exit Code: $exit_code)" "error"
	exit $exit_code
}

check_os() {
	if ! [ -f "/etc/debian_version" ]; then
		log "This script is only supported on Debian-based system" "error"
		exit 1
	fi
}


check_db_connection() {
	if [[ -z "$DB_USER" || -z "$DB_PASSWORD" || -z "$DB_NAME" ]]; then
		handle_error 1 "Missing Necessary Environment Variable"
	fi
	PGPASSWORD=$DB_PASSWORD psql -U $DB_USER -c '\q' || handle_error $? "Unable to connect Database"
}	

db_backup() {
	check_db_connection
	cd ~/db-backup/$(date +%m_%d_%y)
	PGPASSWORD=$DB_PASSWORD pg_dump -U $DB_USER  -F c -b -f $(date +%m_%d_%y).backup  $DB_NAME  || (  rm -f $(date +%m_%d_%y).backup &&  handle_error $? "error taking Pg Dump" )
	log "Created DB backup for $DB_NAME" "success"
	gzip -k $(date +%m_%d_%y).backup || handle_error $? "Failed compressing the backup"
	log "Compressed DB backup for $DB_NAME" "success"
}

check_AWS_CLI_installation() {
	snap list aws-cli || ( sudo snap install aws-cli --classic && log "Installed AWS CLI for connecting ot the cloud" "info" )
	aws s3 ls || handle_error $? "unable to configure to AWS Cloud services"
}

upload_to_s3_bucket() {
	check_AWS_CLI_installation
	aws s3 ls $BUCKET_NAME || ( aws s3 mb s3://$BUCKET_NAME && log "Provided bucket is not in the cloud. so created new one" "info")
	aws s3 cp ~/db-backup/$(date +%m_%d_%y)/$(date +%m_%d_%y).backup.gz  s3://$BUCKET_NAME && log "Backup successfully uploaded to S3" "success" 
}

# main Execution 
main() {
	check_os
	dpkg -l postgresql > /dev/null || handle_error $? " No Postgresql package is installed"
    mkdir -p ~/db-backup/$(date +%m_%d_%y) || handle_error $? "Error creating Directory"	
#	check_db_connection
	db_backup
	upload_to_s3_bucket
}

main
