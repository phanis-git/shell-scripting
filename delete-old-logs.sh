#!/bin/bash

# Delete old logs by doing backup or archieve them

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
P="\e[35m"
C="\e[36m"
N="\e[0m"

# folder & files creation in script
SCRIPTS_FOLDER="/var/log/shell-script-logs"
mkdir -p $SCRIPTS_FOLDER
SCRIPT_FILE_NAME=$(echo $0 | cut -d "." -f1 )
LOG_FILE_NAME="$SCRIPTS_FOLDER/$SCRIPT_FILE_NAME.log"
echo "LOG FILE NAME :: $LOG_FILE_NAME"

# Deleting logs by archieve them
SOURCE_DIRECTORY=$1
DESTINATION_DIRECTORY=$2
DAYS=${3:-14}

# check user has root access or not
ROOT_USER=$(id -u)
if [ $ROOT_USER -ne 0 ]; then
    echo -e "$R Root user privilege is needed $N" | tee -a $LOG_FILE_NAME
    exit 1
fi

# Checking arguments - source and destination path are present in run time shell command 
if [ $# -lt 2 ]; then
    echo -e "$R find <source_path> <destination_path> <days>[optional , if we give days it will take else default it took 14 days older] $N" | tee -a $LOG_FILE_NAME
    exit 1
fi

# Check source and destination directories present or not
if [ ! -d $SOURCE_DIRECTORY ]; then
    echo -e "$R Source directory :: $SOURCE_DIRECTORY is not found $N" | tee -a $LOG_FILE_NAME
    exit 1
fi
if [ ! -d $DESTINATION_DIRECTORY ]; then
    echo -e "$R Destination directory :: $SOURCE_DIRECTORY is not found $N" | tee -a $LOG_FILE_NAME
    exit 1
fi

# Checking & Installing zip 
dnf list installed zip
if [ $? -ne 0 ]; then
    dnf install zip -y
    if [ $? -ne 0 ]; then 
    echo "Zip installation Failure"
    else
    echo "Zip installed Success"
    fi
fi

# Getting files by filtering with .log extension and type is file and respective days
GET_FILES=$(find $SOURCE_DIRECTORY -name "*.log" -type f -mtime +$DAYS)
# condition (some times there are no files inside source folder) 
while IFS= read -r file 
do 
    # if [ ! -z "$file" ]; then
    # echo "Files found and started zipping :: $file"
    # else
    # echo "Files not found"
    # fi

    # or
    if [ -n "$file" ]; then
    TIMESTAMP=$(date +"%F %H:%M:%S")
    DESTINATION_DIRECTORY="${DESTINATION_DIRECTORY%/}"
    ZIP_FILE_NAME="$DESTINATION_DIRECTORY/app-logs-$TIMESTAMP.zip"
    # Zipping the files
    find $SOURCE_DIRECTORY -name "*.log" -type f -mtime +$DAYS | zip -@ -j "$ZIP_FILE_NAME"
    # Checking the files zipped or not
    echo "$ZIP_FILE_NAME"
    if [ -f $ZIP_FILE_NAME ]
        then
         echo "$ZIP_FILE_NAME Successfully archieved"
        #  Deleting
          while IFS= read -r deletingFile
          do 
            echo "Deleting the file $deletingFile"
          done <<< $file
    else
        echo "$ZIP_FILE_NAME Archieve failed"
        exit 1
    fi
    else
    echo "Files not found"
    fi

done <<< $GET_FILES
