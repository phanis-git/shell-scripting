#!/bin/bash

# Deleting logs

source_directory="/home/ec2-user/app-logs"

LogFiles=$(find $source_directory -type f -size -2k -name "*.log")

while IFS= read -r file
do 
    echo "Log files less than 2kb :: $file"
    rm -rf $file
done <<< $LogFiles