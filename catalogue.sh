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


yum install nodejs -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing Nodejs:' $N)"

id roboshop &>> $LOGFILE
if [ $? -eq 0 ]
then 
  echo -e $Y "roboshop user is already exists. proceeding with next steps" $N
else
  echo -e $Y  "Creating roboshop user" $N
  useradd roboshop &>> $LOGFILE
  validate $? "$(echo -e $Y 'user roboshop creation:' $N)"
fi

ls -ld  /app &>> $LOGFILE
if [ $? -eq 0 ]
then
  echo -e $Y "/app is already exists. proceeding with next steps" $N
else
  echo -e $Y  "Creating /app" $N
  mkdir -p /app &>> $LOGFILE
  validate $? "$(echo -e $Y '/app directory creation:' $N)"
fi

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
validate $? "$(echo -e $Y 'Downloading catalogue code:' $N)"

cd /app &>> $LOGFILE
validate $? "$(echo -e $Y 'Switching to /app directory:' $N)"

unzip /tmp/catalogue.zip &>> $LOGFILE
validate $? "$(echo -e $Y 'Extracting code to /tmp:' $N)"

cd /app &>> $LOGFILE
validate $? "$(echo -e $Y 'Switching to /app directory:' $N)"

npm install &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing dependencies:' $N)"

cp /root/office-practice/catalogue.service  /etc/systemd/system/ &>> $LOGFILE
validate $? "$(echo -e $Y 'Creatomg catalogue systemd file:' $N)"

systemctl daemon-reload &>> $LOGFILE
validate $? "$(echo -e $Y 'Reloading systemd:' $N)"

systemctl enable catalogue &>> $LOGFILE
validate $? "$(echo -e $Y 'Enabling catalogue service:' $N)"

systemctl start catalogue &>> $LOGFILE
validate $? "$(echo -e $Y 'Starting catalogue service:' $N)"

mongosh --host $MONGO_HOST --file /app/schema/catalogue.js
validate $? "$(echo -e $Y 'Loading schema:' $N)"
