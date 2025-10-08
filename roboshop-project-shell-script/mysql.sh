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

# folder & files creation in script
scriptsFolder="/var/log/roboshop-project-logs"
mkdir -p $scriptsFolder
scriptFileName=$(echo $0 | cut -d "." -f1 )
echo "scriptname:: $scriptFileName"
logFileName="$scriptsFolder/$scriptFileName.log"
echo "logFileName :: $logFileName"

# Installing mysql-server 
dnf install mysql-server -y $>>$logFileName
VALIDATE $? "Mysql-server installed"

# Enabling mysqld
systemctl enable mysqld
VALIDATE $? "Enabling Mysql-server"

# Starting mysql
systemctl start mysqld  
VALIDATE $? "Starting Mysql-server"

# As we know mysql has default user as root , as we doesnot know the root user password , we are setting 
# password to the root user as RoboShop@1
mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setting root user password in mysql"