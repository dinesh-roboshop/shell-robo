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

dnf install python36 gcc python3-devel -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing python3, gcc and python3-devel packages:' $N)"

app_configure

pip3.6 install -r requirements.txt &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing python requirments:' $N)"

service_configure


