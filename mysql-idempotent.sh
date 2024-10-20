#!/bin/bash
# check id of user ..> id ..> for root user id=0 always
ID=$(id -u)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

echo "Please Enter DB Password:: "
read -s mysql_root_password

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

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

# mysql_secure_installation --set-root-pass ${mysql_root_password}&>> $LOGFILE
# VALIDATE $? "Set Default Root Password to MYSQL"

#Below code will be useful for idempotent nature
# Note: once root password setup we cant change it with '--set-root-pass'
mysql -h db.step-into-iot.cloud -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi