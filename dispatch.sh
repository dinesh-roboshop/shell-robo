#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
MONGO_HOST=mongodb.dineshdevops.shop
COMPONENT=dispatch
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

dnf install golang -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing Golang:' $N)"

app_configure

go mod init dispatch &>> $LOGFILE
go get &>> $LOGFILE
go build &>> $LOGFILE
validate $? "$(echo -e $Y 'Build package for go lang:' $N)"

service_configure
