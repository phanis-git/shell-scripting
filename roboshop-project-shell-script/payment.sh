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


dnf install python3 gcc python3-devel -y &>>$logFileName
VALIDATE $? "Installing python3"

id roboshop
if [ $? -ne 0 ]; then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$logFileName
else
echo -e "$Y Application User already exist $N" | tee -a $logFileName
fi

# creating app directory
mkdir -p /app  &>>$logFileName
VALIDATE $? "Creating app directory"

# Downloading the code
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip &>>$logFileName
VALIDATE $? "Downloading the code"

# Moving to /app 
cd /app  &>>$logFileName
VALIDATE $? "Moving to /app"

# Removing existing code
rm -rf /app/*  &>>$logFileName
VALIDATE $? "Removing existing code"

# Moving to /app 
cd /app  &>>$logFileName
VALIDATE $? "Moving to /app"

# Unzip the code folder or file
unzip /tmp/payment.zip &>>$logFileName
VALIDATE $? "unzip payment file or folder"

# Installing pip3
pip3 install -r requirements.txt &>>$logFileName
VALIDATE $? "Installing pip3"


# Creating system service
cp $SCRIPT_DIRECTORY/payment.service /etc/systemd/system/payment.service &>>$logFileName
VALIDATE $? "Creating system service file here payment.service file to run systemctl command like systemctl start payment"

systemctl daemon-reload &>>$logFileName
VALIDATE $? "daemon-reload"

systemctl enable payment  &>>$logFileName
VALIDATE $? "enable payment"

systemctl start payment &>>$logFileName
VALIDATE $? "start payment"