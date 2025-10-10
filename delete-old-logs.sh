#!/bin/bash

R="\e[31m"
R="\e[32m"
R="\e[33m"
R="\e[34m"
R="\e[35m"
N="\e[0m"


# Deleting logs by archieve them
SOURCE_DIRECTORY=$1
DESTINATION_DIRECTORY=$2
DAYS=${3:-14}

# Check source and destination directories present or not
if [! -d $SOURCE_DIRECTORY ]; then
    echo "Source directory :: $SOURCE_DIRECTORY is not found"
    exit 1
fi
if [ ! -d $DESTINATION_DIRECTORY ]; then
    echo "Destination directory :: $SOURCE_DIRECTORY is not found"
    exit 1
fi

getFiles=$(find $SOURCE_DIRECTORY -name "*.log" -type f -mtime +$DAYS)