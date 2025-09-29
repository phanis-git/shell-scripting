#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
NORMAL_COLOR="\e[0m"
isRootUser=$(id -u)
logFileName="/var/log/shell-script-logs/installation-logs.log"
if [ $isRootUser -eq 0 ]; then
    echo "Root user"
    else 
    echo -e "$RED Root user privelege is needed"
    exit 1
fi
validateInstalls(){
    if [ $1 -eq 0 ]; then
    echo -e "$2 is $GREEN installed successfully $NORMAL_COLOR" 
    else 
    echo -e "$2 is $RED failed to install $NORMAL_COLOR"
    fi 
}
# Installing mysql server and mysql client if not exist
dnf list installed mysql-server
if [ $? -eq 0 ]; then
    echo -e "$GREEN Mysql-server already installed $NORMAL_COLOR" | &>>logFileName
    else 
    dnf install mysql-server -y
    validateInstalls $? "Mysql-server" 
fi

dnf list installed mysql
if [ $? -eq 0 ]; then
    echo -e "$GREEN Mysql-client already installed $NORMAL_COLOR" | &>>logFileName
    else 
    dnf install mysql -y
    validateInstalls $? "Mysql-client" 
fi

dnf list installed nginx
if [ $? -eq 0 ]; then
    echo -e "$GREEN Nginx already installed $NORMAL_COLOR" | &>>logFileName
    else 
    dnf install nginx -y
    validateInstalls $? "Nginx" 
fi



