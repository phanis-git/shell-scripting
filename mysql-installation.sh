#!/bin/bash


# Before writing shell script first we need to note what are all the steps need to do


# Steps to install mysql-server 
# 1. Check the user has root access or not
# 2. If root then procced for download mysql-server else warn to run like root
# 3. Check mysql-server is already installed or not 
# 4. If Already installed notify user already installed else 
# 5. Install mysql-server 
# 6. Check if mysql-server is properly installed or not 
# 7. If properly installed then notify user with success else failure

# getting user id
rootUserId=$(id -u)
# checking root user or not
if [ $rootUserId -ne 0 ]; then
    echo "Try with root user "
    exit 1
fi

# checking if package already exist or not
dnf list installed mysql-server
if [ $? -ne 0 ]; then
    dnf install mysql-server -y
    if [ $? -ne 0 ]; then
        echo "Mysql-server is failed install"
        else
        echo "Mysql-server is installed successfully"
    fi
    else
    echo "Mysql-server is already exist"
    exit 1
fi    











