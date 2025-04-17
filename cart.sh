#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
MONGO_HOST=13.218.81.249
COMPONENT=cart

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


yum install nodejs -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing Nodejs:' $N)"

## calling app_configure function
app_configure

npm install &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing dependencies:' $N)"

service_configure


