#!/bin/bash

# Error handling for arguments: 0-3 allowed, otherwise display an error
if [ $# -gt 3 ]; then
    echo "Error: Too many arguments provided."
    echo "Usage: $0 [file_type1] [file_type2] [file_type3]"
    echo "Example: $0 .c .txt .pdf"
    exit 1
fi

# Set file types to backup, or default to all files if no arguments are provided
if [ $# -eq 0 ]; then
    # No arguments, so consider all files
    file_types="-name '*'"
else
    # Construct the find command with the provided file types
    file_types=""
    for arg in "$@"; do
        # Append each file type argument to the find command with -o (logical OR)
        file_types="$file_types -o -name '*$arg'"
    done
    # Remove the leading "-o " and wrap in parentheses for the find command
    file_types="\( ${file_types:4} \)" 
fi

# Home directory and backup directory setup
HOME_DIR="/home/baskar31/assignment"
BACKUP_DIR="$HOME_DIR/backup"
CBUP_DIR="$BACKUP_DIR/cbup24s"
IBUP_DIR="$BACKUP_DIR/ibup24s"
DBUP_DIR="$BACKUP_DIR/dbup24s"
BACKUP_LOG_FILE="$BACKUP_DIR/backup.log"

# Ensure the backup directories exist
mkdir -p $CBUP_DIR $IBUP_DIR $DBUP_DIR

# Initialize backup counters for each type of backup
cbup_counter=0
ibup_counter=0
dbup_counter=0 

# Function to create a complete backup
create_complete_backup() {
    # Increment the complete backup counter
    ((cbup_counter++))
    # Create the tar file name with the incremented counter
    file_name="cbup24s-$cbup_counter.tar"
    # Construct the find command to locate all files matching the criteria
    find_command="find $HOME_DIR -type f $file_types"
    # Execute the find command and store the result in files
    files=$(eval $find_command)
    # If no files found, output a message; otherwise, create the tar file
    if [ -z "$files" ]; then
        echo "No files found"
    else
        tar -cf "$CBUP_DIR/$file_name" $files
        # Log the backup creation time and file name
        echo "$(date '+%a %d %b %Y %I:%M:%S %p %Z') $file_name was created" >> $BACKUP_LOG_FILE
        echo "$(date '+%a %d %b %Y %I:%M:%S %p %Z') $file_name was created"
    fi
}

# Function to create an incremental backup
create_incremental_backup() {
    # Increment the incremental backup counter
    ((ibup_counter++))
    # Create the tar file name with the incremented counter
    file_name="ibup24s-$ibup_counter.tar"
    # Store the time of the last backup for comparison
    last_backup_time="$1"
    # Construct the find command to locate files modified after the last backup
    find_command="find $HOME_DIR -type f $file_types -newermt '$last_backup_time'"
    # Execute the find command and store the result in files
    files=$(eval $find_command)
    # If no files found, log a message and decrement the counter; otherwise, create the tar file
    if [ -z "$files" ]; then
        echo "$(date '+%a %d %b %Y %I:%M:%S %p %Z') No changes - Incremental backup was not created" >> $BACKUP_LOG_FILE
        echo "$(date '+%a %d %b %Y %I:%M:%S %p %Z') No changes - Incremental backup was not created"
        ((ibup_counter--))
    else
        tar -cf "$IBUP_DIR/$file_name" $files
        # Log the backup creation time and file name
        echo "$(date '+%a %d %b %Y %I:%M:%S %p %Z') $file_name was created" >> $BACKUP_LOG_FILE
        echo "$(date '+%a %d %b %Y %I:%M:%S %p %Z') $file_name was created"
    fi
}

# Function to create a differential backup
create_differential_backup() {
    # Increment the differential backup counter
    ((dbup_counter++))
    # Create the tar file name with the incremented counter
    file_name="dbup24s-$dbup_counter.tar"
    # Store the time of the last complete backup for comparison
    last_complete_backup="$1"
    # Construct the find command to locate files modified after the last complete backup
    find_command="find $HOME_DIR -type f $file_types -newermt '$last_complete_backup'"
    # Execute the find command and store the result in files
    files=$(eval $find_command)
    # If no files found, log a message and decrement the counter; otherwise, create the tar file
    if [ -z "$files" ]; then
        echo "$(date '+%a %d %b %Y %I:%M:%S %p %Z') No changes - Differential backup was not created" >> $BACKUP_LOG_FILE
        echo "$(date '+%a %d %b %Y %I:%M:%S %p %Z') No changes - Differential backup was not created"
        ((dbup_counter--))
    else
        tar -cf "$DBUP_DIR/$file_name" $files
        # Log the backup creation time and file name
        echo "$(date '+%a %d %b %Y %I:%M:%S %p %Z') $file_name was created" >> $BACKUP_LOG_FILE
        echo "$(date '+%a %d %b %Y %I:%M:%S %p %Z') $file_name was created"
    fi
}

# Continuous loop to run the backup process indefinitely
while true; do
    echo STEP 1: Create a complete backup
    create_complete_backup
    last_complete_backup=$(date +"%Y-%m-%d %H:%M:%S")  # Store the time of the complete backup
    echo "Last complete backup time: $last_complete_backup"
    echo complete backup done
    echo " "
    echo " "

    echo STEP 2: Create an incremental backup
    sleep 120  
    echo Wait for 2 minutes
    create_incremental_backup "$last_complete_backup"
    last_incremental_backup=$(date +"%Y-%m-%d %H:%M:%S")  # Store the time of the incremental backup
    echo "Last incremental backup time: $last_incremental_backup"
    echo Incremental backup done
    echo " "
    echo " "

    echo STEP 3: Create another incremental backup
    sleep 120  
    echo Wait for 2 minutes
    create_incremental_backup "$last_incremental_backup"
    last_incremental_backup=$(date +"%Y-%m-%d %H:%M:%S")  # Store the time of the second incremental backup
    echo "Last incremental backup time: $last_incremental_backup"
    echo Incremental backup done
    echo " "
    echo " "

    echo STEP 4: Create a differential backup after the complete backup
    sleep 120  
    echo Wait for 2 minutes
    create_differential_backup "$last_complete_backup"
    last_differential_backup=$(date +"%Y-%m-%d %H:%M:%S")  # Store the time of the differential backup
    echo "Last differential backup time: $last_differential_backup"
    echo Differential backup done
    echo " "
    echo " "

    echo STEP 5: Create an incremental backup after the differential backup
    sleep 120  
    echo Wait for 2 minutes
    create_incremental_backup "$last_differential_backup"
    last_incremental_backup=$(date +"%Y-%m-%d %H:%M:%S")  # Store the time of the third incremental backup
    echo "Last incremental backup time: $last_incremental_backup"
    echo Incremental backup done
    echo " "
    echo " "

    # Continue the loop indefinitely
    echo CONTINUOUS LOOP...
    echo " "
    echo " "
done
