#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
MONGO_HOST=mongodb.dineshdevops.shop
COMPONENT=cart
LOCATION="/root/shell-robo"

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



dnf module disable nodejs -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Disabling nodejs:' $N)"

dnf module enable nodejs:18 -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Enabling nodejs18:' $N)"

dnf install nodejs -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing Nodejs:' $N)"

## calling app_configure function
app_configure

npm install &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing dependencies:' $N)"

service_configure


