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
        echo -e "Installing $2 ... $R FAILURE $N" | tee -a $logFileName
        exit 1
    else
        echo -e "Installing $2 ... $G SUCCESS $N" | tee -a $logFileName
    fi
}

# folder & files creation in script
scriptsFolder="/var/log/shell-script-logs"
mkdir $scriptsFolder
scriptFileName=$(echo $0 | cut -d "." -f1 )
echo "scriptname:: $scriptFileName"
logFileName="$scriptsFolder/$scriptFileName.log"
echo "logFileName :: $logFileName"

allPackages=$@

for package in $allPackages
do
dnf list installed $package &>>$logFileName
# Install if it is not found
if [ $? -ne 0 ]; then
    dnf install $package -y &>>$logFileName
    VALIDATE $? "$package"
else
    echo -e "$package already exist ... $Y SKIPPING $N" | tee -a $logFileName
fi
done 
