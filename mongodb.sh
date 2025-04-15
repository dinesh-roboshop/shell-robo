#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

validate () {
if [ $1 -eq 0 ]
then
   echo -e "$2 $G SUCCESS $N"
else
   echo -e "$2 $R FAILUTE $N"	
   exit 1
fi

}

if [ $(id -u) -eq 0 ]
then
  echo -e $Y "You are logged in as root user. proceeding with configuration" $N
else
   echo -e $R "Please login as root user to proceed with installatiojn" $N
   exit 1
fi

cp /root/roboshop/mongodb-org-7.0.repo  /etc/yum.repos.d/ &>> $LOGFILE
validate $? "$(echo $Y 'Copying mongodb repo:' $N)"

yum update &>> $LOGFILE; yum install mongodb-org -y  &>> $LOGFILE
validate $? "$(echo $Y 'Installing mongodb:' $N)" 

systemctl enable mongod &>> $LOGFILE
validate $? "$(echo $Y 'Enabling mongodb:' $N)"

systemctl start mongod  &>> $LOGFILE
validate $? "$(echo $Y 'Starting mongodb:' $N)"

