#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

validate ( ) {
  if [ $1 -eq 0 ]
  then
    echo -e $2 $G "SUCCESS" $N
  else
    echo -e $2 $R  "FAILED" $N
    exit 1
  fi

}

source ./functions.sh

check_root_user


cp /root/office-practice/mysql.repo /etc/yum.repos.d/ &>> $LOGFILE
validate $? "$(echo -e $Y 'Copying mysal repo:' $N)"

dnf install mysql-community-server -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing mysql server:' $N)"

systemctl enable mysqld &>> $LOGFILE
validate $? "$(echo -e $Y 'Enabling mysql service:' $N)"

systemctl start mysqld &>> $LOGFILE
validate $? "$(echo -e $Y 'Starting mysql service:' $N)"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
validate $? "$(echo -e $Y 'Changing default ROOT password to start db:' $N)"

mysql -uroot -pRoboShop@1 &>> $LOGFILE
validate $? "$(echo -e $Y 'verifying mysql db:' $N)"

