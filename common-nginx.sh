#!/bin/bash

source ./common.sh 
CHECK_ROOT

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