#!/bin/bash

# Redis:-
# Redis (REmote DIctionary Server) is an open-source, in-memory data store used as a database, cache. 
# It is known for ultra-fast performance due to its in-memory(stores in RAM) architecture. 
# Uses a simple key-value model but supports complex data types.
set -euo pipefail
trap 'There is an error in line number :: $LINENO and the command is $BASH_COMMAND' ERR

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SCRIPT_DIR=$PWD

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privelege" | tee -a $logFileName
    exit 1 # failure is other than 0
fi


logsFolder="/var/log/roboshop-project-logs"
mkdir -p $logsFolder
scriptFileName=$(echo $0 | cut -d "." -f1 )
logFileName="$logsFolder/$scriptFileName.log"
echo "Log file name :: $logFileName"



# Disable default version of Redis
echo "Disabling default redis version"
dnf module disable redis -y &>>$logFileName

# Enable version of 7
echo "Enabling redis version 7"
dnf module enable redis:7 -y &>>$logFileName

# Installing Redis
echo "Installing redis version 7"
dnf install redis -y &>>$logFileName

# Giving Remote access connections with 0.0.0.0 by changing the default port 127.0.0.1
echo "Allowing remote connections from port 0.0.0.0"
sed -i '127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>$logFileName

# Changing protected-mode yes to no
echo "Changing protected-mode yes to no"
sed -i 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf &>>$logFileName

# systemctl enable redis
echo "Enabling Redis"
systemctl enable redis &>>$logFileName

# systemctl start redis
echo "Started Redis"
systemctl start redis &>>$logFileName
