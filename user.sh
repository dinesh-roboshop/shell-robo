#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
MONGO_HOST=13.218.81.249

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

yum install nodejs -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing Nodejs:' $N)"
## calling app_configure function

app_configure

npm install &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing dependencies:' $N)"

cp /root/office-practice/user.service  /etc/systemd/system/ &>> $LOGFILE
validate $? "$(echo -e $Y 'Creatomg user systemd file:' $N)"

systemctl daemon-reload &>> $LOGFILE
validate $? "$(echo -e $Y 'Reloading systemd:' $N)"

systemctl enable user  &>> $LOGFILE
validate $? "$(echo -e $Y 'Enabling user  service:' $N)"

systemctl start user &>> $LOGFILE
validate $? "$(echo -e $Y 'Starting user  service:' $N)"

mongosh --host $MONGO_HOST --file /app/schema/user.js
validate $? "$(echo -e $Y 'Loading schema:' $N)"
