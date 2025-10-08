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
scriptsFolder="/var/log/expense-project-logs"
mkdir $scriptsFolder
scriptFileName=$(echo $0 | cut -d "." -f1 )
echo "scriptname:: $scriptFileName"
logFileName="$scriptsFolder/$scriptFileName.log"
echo "logFileName :: $logFileName"


# Installing mysql-server 
dnf list installed mysql-server &>>$logFileName
if [ $? -eq 0 ]; then
    echo -e "$G Installing mysql-server $N" | tee -a $logFileName
    dnf install mysql-server -y &>>$logFileName
    VALIDATE $? "Mysql installation"
else
    echo -e "$Y Mysql already installed $N"
fi

# enable mysqld
systemctl enable mysqld
VALIDATE $? "Enable mysql"

# start mysql
systemctl start mysqld
VALIDATE $? "Start mysql"

# setting mysql root user password
mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "Setting mysql root user password"


