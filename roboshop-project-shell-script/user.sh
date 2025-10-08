#!/bin/bash


USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SCRIPT_DIRECTORY=$PWD

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

# folder & files creation in script
scriptsFolder="/var/log/roboshop-project-logs"
mkdir -p $scriptsFolder
scriptFileName=$(echo $0 | cut -d "." -f1 )
echo "scriptname:: $scriptFileName"
logFileName="$scriptsFolder/$scriptFileName.log"
echo "logFileName :: $logFileName"

# Disabling default nodejs version
dnf module disable nodejs -y &>>$logFileName
VALIDATE $? "Disabling default nodejs version"

# Enabling 20 version of nodejs
dnf module enable nodejs:20 -y &>>$logFileName
VALIDATE $? "Enabling nodejs version 20"

# Installing nodejs
dnf install nodejs -y &>>$logFileName
VALIDATE $? "Installing nodejs version 20"

# Adding system user with no logins
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$logFileName
VALIDATE $? "Adding system user"

# Creating app directory
mkdir -p /app  &>>$logFileName
VALIDATE $? "Creating app directory"

# Downloading the code to /tmp folder
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip  
VALIDATE $? "Downloading the code to /tmp folder"

# Moving to /app folder
cd /app &>>$logFileName
VALIDATE $? "Moving to /app folder"

# Unzip the /tmp/user.zip
unzip /tmp/user.zip &>>$logFileName
VALIDATE $? "Unzip the user.zip"

# Moving to /app folder
cd /app &>>$logFileName
VALIDATE $? "Moving to /app folder for installing dependencies"

# Installing dependencies
npm install   &>>$logFileName
VALIDATE $? "Installed dependencies"

# Creating service file for running user.service
cp $SCRIPT_DIRECTORY/user.service /etc/systemd/system/user.service  &>>$logFileName
VALIDATE $? "Created service file for user to run systemctl commands"

# Reloading  or Load the service.
systemctl daemon-reload
VALIDATE $? "daemon-reload"

# Enable user service or user
systemctl enable user 
VALIDATE $? "enable user"

# Start user service or user
systemctl start user
VALIDATE $? "Started user"