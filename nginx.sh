#!/bin/bash
# check id of user ..> id ..> for root user id=0 always
ID=$(id -u)

if [ $ID -ne 0 ]; 
    then
        echo "Please run this script as super user."
        exit 1
    else
        echo "You are super user."
fi

SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

echo "Please Enter DB Password:: "
read -s mysql_root_password

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

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

dnf install nginx -y  &>> $LOGFILE
VALIDATE $? "Installation nginx" 

systemctl start nginx &>> $LOGFILE
VALIDATE $? "Starting nginx" 

systemctl enable nginx &>> $LOGFILE
VALIDATE $? "Enable nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE
VALIDATE $? "Remove old files"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>> $LOGFILE
VALIDATE $? "Download Code"

cd /usr/share/nginx/html &>> $LOGFILE
VALIDATE $? "change folder to /usr/share/nginx/html"

unzip /tmp/frontend.zip &>> $LOGFILE
VALIDATE $? "unzip code"

cp /home/ec2-user/expense-project-shell/expense.conf /etc/nginx/default.d/expense.conf &>> $LOGFILE
VALIDATE $? "Copy expense config"

systemctl restart nginx &>> $LOGFILE
VALIDATE $? "Restart nginx" 