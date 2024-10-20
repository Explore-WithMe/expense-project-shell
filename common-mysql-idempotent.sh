#!/bin/bash
# check id of user ..> id ..> for root user id=0 always

# chmod +x common.sh 
source ./common.sh 
CHECK_ROOT

echo "Please Enter DB Password:: "
read -s mysql_root_password

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