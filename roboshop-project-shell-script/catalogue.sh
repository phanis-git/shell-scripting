#!/bin/bash

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


# Disable default nodejs
dnf module disable nodejs -y &>>$logFileName
VALIDATE $? "Disabling default nodejs"

# Enable required nodejs version here 20
dnf module enable nodejs:20 -y &>>$logFileName
VALIDATE $? "Enabling nodejs version 20"

# Installing version 20 nodejs
dnf install nodejs -y &>>$logFileName
VALIDATE $? "Installing nodejs version 20"

# Adding application user by checking user exist or not
id roboshop
if [ $? -ne 0 ]; then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$logFileName
VALIDATE $? "Adding application user"
else
echo -e "$Y Application User already exist $N" | tee -a $logFileName
fi

# Creating app directory
mkdir -p /app 
VALIDATE $? "Creating app directory"

# Download code to tmp directory
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$logFileName
VALIDATE $? "Downloading code"

# Moving to app directory
cd /app 
VALIDATE $? "Moving to app directory"

# Removing the existing code for new code changes incoming
rm -rf /app/*
VALIDATE $? "Removing existing code"
# Unzip the code folder (as we run multiple times it will struck because there is already code present so 
# above i am removing the code)
unzip /tmp/catalogue.zip &>>$logFileName
VALIDATE $? "Unzip the code folder"

# Moving to app directory for installing packages
cd /app 
VALIDATE $? "Moving to app directory for installing packages"

# Doing npm install
npm install &>>$logFileName
VALIDATE $? "Doing npm install"

# Creating systemctl (here we taken a seperate file for creating - catalogue.service )by file
# As we are in /app directory 
echo " prwsent working dir :: $SCRIPT_DIR"
cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service &>>$logFileName
VALIDATE $? "Copy and pasted the catalogue service file to /etc/systemd/system"

# Daemon reload
systemctl daemon-reload &>>$logFileName
VALIDATE $? "Daemon reload"

# Enable catalogue service
systemctl enable catalogue &>>$logFileName
VALIDATE $? "Enable catalogue service"

# Start catalogue service
systemctl start catalogue &>>$logFileName
VALIDATE $? "Start catalogue service"

# Copying mongo.repo to /etc/yum.repos.d/mongo.repo
cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>>$logFileName
VALIDATE $? "Copy and pasted the mongo repo content to /etc/yum.repos.d/mongo.repo"

# Installing mongodb client for interacting app server and db server
# Here mongodb-mongosh is the client package for mongodb
# *** Before installing the repo should be there in the server
dnf install mongodb-mongosh -y &>>$logFileName
VALIDATE $? "Installing mongodb client package or mongodb-mongosh"

# Loading data into the db for sample purpose
# mongosh --host mongodb.devops-phani.fun </app/db/master-data.js &>>$logFileName
# VALIDATE $? "Loading catalogue products data to the db for sample purpose"

INDEX=$(mongosh mongodb.devops-phani.fun --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ]; then
    mongosh --host mongodb.devops-phani.fun </app/db/master-data.js &>>$logFileName
else
    echo -e "Catalogue products already loaded ... $Y SKIPPING $N"
fi

# Restart catalogue service
systemctl restart catalogue &>>$logFileName
VALIDATE $? "Restart catalogue service"