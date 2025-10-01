#!/bin/bash

# Here i will keep all the variables and functions at top
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
PURPLE="\e[35m"
CEON="\e[36m"
WHITE="\e[37m"
NORMAL_COLOR="\e[0m"

# Here we are using funtions to reduce code for 

validateInstallation(){
    if [ $1 -ne 0 ]; then 
        echo -e "$RED $2 is failed install $NORMAL_COLOR"
    else 
        echo -e "$GREEN $2 is installed successfully $NORMAL_COLOR"
    fi
}   


# Before writing shell script first we need to note what are all the steps need to do


# Steps to install mysql-server  and nginx
# 1. Check the user has root access or not
# 2. If root then procced for download mysql-server else warn to run like root
# 3. Check mysql-server is already installed or not 
# 4. If Already installed notify user already installed else 
# 5. Install mysql-server 
# 6. Check if mysql-server is properly installed or not 
# 7. If properly installed then notify user with success else failure
# 8. Next same like Nginx


# getting user id
rootUserId=$(id -u)
# checking root user or not
if [ $rootUserId -ne 0 ]; then
    echo -e "$RED Try with root user $NORMAL_COLOR"
    exit 1
fi

# checking if mysql-server package already exist or not
dnf list installed mysql-server
if [ $? -ne 0 ]; then
    dnf install mysql-server -y
    validateInstallation $? "Mysql-server"
    else
    echo -e "$BLUE Mysql-server is already exist $NORMAL_COLOR"
fi    

# checking if nginx package already exist or not
dnf list installed nginx
if [ $? -ne 0 ]; then
    dnf install nginx -y
    validateInstallation $? "Nginx"
    else
    echo -e "$BLUE Nginx is already exist $NORMAL_COLOR"
fi  









