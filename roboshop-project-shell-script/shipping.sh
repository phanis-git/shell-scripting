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

# Installing Maven
dnf install maven -y &>>$logFileName
VALIDATE $? "Installed Maven"

# Adding app user or non human user
id roboshop
if [ $? -ne 0 ]; then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$logFileName
VALIDATE $? "Adding app user"
else
echo -e "$Y Application User already exist $N" | tee -a $logFileName
fi

# Creating app directory
mkdir -p /app &>>$logFileName
VALIDATE $? "Creating app directory"

# Downloading the code to /tmp folder
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip 
VALIDATE $? "Downloading the code to /tmp folder"

# Moving to /app folder
cd /app &>>$logFileName
VALIDATE $? "Moving to /app folder"

rm -rf /app/*
VALIDATE $? "Removing existing code"

# Unzip the /tmp/user.zip
unzip /tmp/shipping.zip &>>$logFileName
VALIDATE $? "Unzip the user.zip"

# Moving to /app folder
cd /app  &>>$logFileName
VALIDATE $? "Moving to /app folder"

# MVN CLEAN package as it is java 
mvn clean package  &>>$logFileName
VALIDATE $? "mvn clean package"

# Once package done by above command jar file is created 
mv target/shipping-1.0.jar shipping.jar  &>>$logFileName
VALIDATE $? "Moving jar file"

# creating service file to run systemctl commands
cp $SCRIPT_DIRECTORY/shipping.service /etc/systemd/system/shipping.service &>>$logFileName
VALIDATE $? "Creating shipping service"

# Daemon reload
systemctl daemon-reload &>>$logFileName
VALIDATE $? "daemon-reload"

# Enable shipping service
systemctl enable shipping  &>>$logFileName
VALIDATE $? "Enable shipping service"

# Start shipping service
systemctl start shipping &>>$logFileName
VALIDATE $? "Start shipping service"

# Installing mysql client package
dnf install mysql -y  &>>$logFileName
VALIDATE $? "Installing mysql client package"

mysql -h $mysql.devops-phani.fun -uroot -pRoboShop@1 -e 'use cities' &>>$logFileName
if [ $? -ne 0 ]; then
    mysql -h $mysql.devops-phani.fun -uroot -pRoboShop@1 < /app/db/schema.sql &>>$logFileName
    mysql -h $mysql.devops-phani.fun -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$logFileName
    mysql -h $mysql.devops-phani.fun -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$logFileName
else
    echo -e "Shipping data is already loaded ... $Y SKIPPING $N"
fi

systemctl restart shipping  &>>$logFileName
VALIDATE $? "Restarted shipping and done"