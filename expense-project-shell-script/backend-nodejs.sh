#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privelege" | tee -a $logFileName
    exit 1 # failure is other than 0
fi

VALIDATE(){ # functions receive inputs through args just like shell script args
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $logFileName
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a $logFileName
    fi
}

scriptsFolder="/var/log/expense-project-logs"
mkdir $scriptsFolder
scriptFileName=$(echo $0 | cut -d "." -f1 )
echo "scriptname:: $scriptFileName"
logFileName="$scriptsFolder/$scriptFileName.log"
echo "logFileName :: $logFileName"

# Disable default nodejs version
dnf module disable nodejs -y &>>$logFileName
VALIDATE $? "Disable default nodejs version"

# enable particular nodejs version
dnf module enable nodejs:20 -y &>>$logFileName
VALIDATE $? "Enable nodejs version with 20"

# Installing nodejs
dnf install nodejs -y &>>$logFileName
VALIDATE $? "Installing nodejs version with 20"

# Adding application user
# here we need to write if condition for user exist or not
useradd expense               
VALIDATE $? "Adding application User"

# creating app directory
# here we need to write if condition for directory exist or not
mkdir /app
VALIDATE $? "Creating app directory"

# downloading code
curl -o /tmp/backend.zip https://expense-joindevops.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "Downloading code to tmp folder"

# moving to app directory
cd /app
VALIDATE $? "Moving to app directory"

# Installing dependencies 
npm install
VALIDATE $? "Installing dependencies"

# creating service file for system
vim /etc/systemd/system/backend.service
