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

dnf list installed mysql &>>$logFileName
# Install if it is not found
if [ $? -ne 0 ]; then
    dnf install mysql -y &>>$logFileName
    VALIDATE $? "MySQL"
else
    echo -e "MySQL already exist ... $Y SKIPPING $N" | tee -a $logFileName
fi

dnf list installed nginx &>>$logFileName
if [ $? -ne 0 ]; then
    dnf install nginx -y &>>$logFileName
    VALIDATE $? "Nginx"
else
    echo -e "Nginx already exist ... $Y SKIPPING $N" | tee -a $logFileName
fi

dnf list installed python3 &>>$logFileName
if [ $? -ne 0 ]; then
    dnf install python3 -y &>>$logFileName
    VALIDATE $? "python3"
else
    echo -e "Python3 already exist ... $Y SKIPPING $N" | tee -a $logFileName
fi