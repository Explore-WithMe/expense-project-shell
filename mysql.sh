#!/bin/bash
# check id of user ..> id ..> for root user id=0 always
ID=$(id -u)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
N="\e[0m"

if [ $ID -ne 0 ]; 
    then
        echo "Please run this script as super user."
        exit 1
    else
        echo "You are super user."
fi

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        # without '-e' colors will not execute
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

dnf install mysql-server -y &>> $LOGFILE
VALIDATE $? "Installation MYSQL" 

systemctl start mysqld &>> $LOGFILE
VALIDATE $? "Starting MYSQL" 

systemctl enable mysqld &>> $LOGFILE
VALIDATE $? "Enable MYSQL"

mysql_secure_installation --set-root-pass ExpenseApp@1&>> $LOGFILE
VALIDATE $? "Set Default Passworf to MYSQL"