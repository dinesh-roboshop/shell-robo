#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
LOCATION="/root/shell-robo"

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


cp $LOCATION/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE
validate $? "$(echo -e $Y 'Copying mysql repo:' $N)"

dnf module disable mysql -y &>> $LOGFILE
validate $? "$(echo -e $Y 'disabling mysql repo:' $N)"


dnf clean all &>> $LOGFILE
dnf makecache &>> $LOGFILE


dnf install mysql-community-server -y  &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing mysql server:' $N)"

systemctl enable mysqld &>> $LOGFILE
validate $? "$(echo -e $Y 'Enabling mysql service:' $N)"

systemctl start mysqld &>> $LOGFILE
validate $? "$(echo -e $Y 'Starting mysql service:' $N)"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
validate $? "$(echo -e $Y 'Changing default ROOT password to start db:' $N)"

#mysql -uroot -pRoboShop@1 &>> $LOGFILE
#validate $? "$(echo -e $Y 'verifying mysql db:' $N)"

