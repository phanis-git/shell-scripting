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





# using functions for reduce code

rootUserId=$(id -u)
if [ $rootUserId -eq 0 ]; then
    else 
    echo "Try with root access"
    exit 1
fi
    dnf install mysql-server -y
    install_status=$?
    validateInstall $install_status "Mysql-server"

    dnf install mysql -y
    install_status=$?
    validateInstall $install_status "Mysql-client"

    dnf install nginx -y
    install_status=$?
    validateInstall $install_status "Nginx"

    validateInstall(){
    if [ $1 -eq 0 ]; then
        echo "$2 installed successfully"
    else 
        echo "$2 installation failure"
    fi
    }