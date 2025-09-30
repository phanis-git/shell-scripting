#!/bin/bash

# rootUserId=$(id -u)
# if [ $rootUserId -eq 0 ]; then
#     else 
#     echo "Try with root access"
#     exit 1
# fi
#     dnf install mysql-server -y
#     mysql_server_install_status=$?
#     if [ $mysql_server_install_status -eq 0 ]; then
#         echo "Mysql-server installed successfully"
#     else 
#         echo "Mysql-server installation failure"
#     fi 
#     dnf install mysql -y
#     mysql_client_package=$?
#     if [ $mysql_client_package -eq 0 ]; then
#         echo "Mysql client package installed successfully"
#     else 
#         echo "Mysql client package installation failure"
#     fi 





# # using functions for reduce code

# rootUserId=$(id -u)
# if [ $rootUserId -eq 0 ]; then
#     echo "Yes you have root access"
#     else 
#     echo "Try with root access"
#     exit 1
# fi
#     dnf install mysql-server -y
#     install_status=$?
#     validateInstall $install_status "Mysql-server"

#     dnf install mysql -y
#     install_status=$?
#     validateInstall $install_status "Mysql-client"

#     dnf install nginx -y
#     install_status=$?
#     validateInstall $install_status "Nginx"

#     validateInstall(){
#     if [ $1 -eq 0 ]; then
#         echo "$2 installed successfully"
#     else 
#         echo "$2 installation failure"
#     fi
#     }










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



# Before writing shell script first we need to note what are all the steps need to do


# Steps to install mysql-server  and nginx
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
    echo -e "$RED Try with root user $NORMAL_COLOR"
    exit 1
fi

# checking if mysql-server package already exist or not
dnf list installed mysql-server
if [ $? -ne 0 ]; then
    dnf install mysql-server -y
    if [ $? -ne 0 ]; then
        echo -e "$RED Mysql-server is failed install $NORMAL_COLOR"
        else
        echo -e "$GREEN Mysql-server is installed successfully $NORMAL_COLOR"
    fi
    else
    echo -e "$BLUE Mysql-server is already exist $NORMAL_COLOR"
fi    

# checking if nginx package already exist or not
dnf list installed nginx
if [ $? -ne 0 ]; then
    dnf install nginx -y
    if [ $? -ne 0 ]; then
        echo -e "$RED Nginx is failed install $NORMAL_COLOR"
        else
        echo -e "$GREEN Nginx is installed successfully $NORMAL_COLOR"
    fi
    else
    echo -e "$BLUE Nginx is already exist $NORMAL_COLOR"
fi  









