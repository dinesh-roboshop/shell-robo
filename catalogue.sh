#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
MONGO_HOST=mongodb.dineshdevops.shop
COMPONENT=catalogue

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

app_configure

npm install &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing dependencies:' $N)"

service_configure

cp /root/office-practice/mongodb-org-7.0.repo /etc/yum.repos.d/  &>> $LOGFILE
validate $? "$(echo -e $Y 'Copying mongo client repo:' $N)"

yum update &>> $LOGFILE; yum install mongodb-org -y  &>> $LOGFILE
validate $? "$(echo $Y 'Installing mongodb client shell:' $N)"

mongosh --host $MONGO_HOST --file /app/schema/catalogue.js
validate $? "$(echo -e $Y 'Loading schema:' $N)"
