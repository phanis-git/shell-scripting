#!/bin/bash

# RabbitMQ is a messaging Queue which is used by some components of the applications.

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


# Setting repo file in /etc/yum/repos.d
cp $SCRIPT_DIRECTORY/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$logFileName
VALIDATE $? "Setting rabbitmq.repo"

# Installing rabbitmq-server 
dnf install rabbitmq-server -y &>>$logFileName
VALIDATE $? "Installing rabbitmq-server"

# Enabling rabbitmq-server 
systemctl enable rabbitmq-server &>>$logFileName
VALIDATE $? "Enabling rabbitmq-server"

# Starting rabbitmq-server 
systemctl start rabbitmq-server &>>$logFileName
VALIDATE $? "Started rabbitmq-server"

# RabbitMQ comes with a default username / password as guest/guest. 
# But this user cannot be used to connect. Hence, we need to create one user for the application.
# Adding roboshop user
id roboshop
if [ $? -ne 0 ]; then
rabbitmqctl add_user roboshop roboshop123 &>>$logFileName
VALIDATE $? "Adding application user"
else
echo -e "$Y Application User already exist $N" | tee -a $logFileName
fi

# Setting permissions
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$logFileName
VALIDATE $? "Setting permissions to application user"

