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


# Disabling default nginx version
dnf module disable nginx -y &>>$logFileName
VALIDATE $? "Disabling default nginx version"

# Enabling 1.24 
dnf module enable nginx:1.24 -y &>>$logFileName
VALIDATE $? "Enabling 1.24 nginx version"

# Installing nginx
dnf install nginx -y &>>$logFileName
VALIDATE $? "Installing nginx"

# Enable nginx
systemctl enable nginx &>>$logFileName
VALIDATE $? "enable nginx"

# start nginx
systemctl start nginx  &>>$logFileName
VALIDATE $? "start nginx"

# Removing default content in html
rm -rf /usr/share/nginx/html/*  &>>$logFileName
VALIDATE $? "Removing default content in html"

# Downloading latest code
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$logFileName
VALIDATE $? " Downloading latest code"

# Navigating to /usr/share/nginx/html
cd /usr/share/nginx/html  &>>$logFileName
VALIDATE $? "Navigating to /usr/share/nginx/html"

# Unzip
unzip /tmp/frontend.zip &>>$logFileName
VALIDATE $? "Unzip frontend code folder or file"

# Removing existing configuration in /etc/nginx/nginx.conf
rm -rf /etc/nginx/nginx.conf &>>$logFileName
VALIDATE $? "Removing existing configuration in /etc/nginx/nginx.conf"

cp $SCRIPT_DIRECTORY/nginx.conf /etc/nginx/nginx.conf &>>$logFileName
VALIDATE $? "Placing latest nginx.conf in /etc/nginx/nginx.conf"

systemctl restart nginx  &>>$logFileName
VALIDATE $? "Restarted nginx "