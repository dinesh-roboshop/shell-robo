#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
MONGO_HOST=13.218.81.249
COMPONENT=payment

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"


if [ $(id -u) -eq 0 ]
then
  echo -e $Y "You are root user. Proceeding with installation" $N
else
  echo -e $R "You are NOT ROOT USER. Please login as ROOT to proceed with installation" $N
  exit 1
fi

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

dnf install python3 python3-pip gcc python3-devel -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing python3, gcc and python3-devel packages:' $N)"

app_configure

pip3 install -r requirements.txt &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing python requirments:' $N)"

service_configure


