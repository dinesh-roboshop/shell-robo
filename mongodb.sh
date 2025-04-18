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

source ./functions.sh
check_root_user

cp /root/office-practice/mongo.repo  /etc/yum.repos.d/mongo.repo &>> $LOGFILE
validate $? "$(echo $Y 'Copying mongodb repo:' $N)"

yum install mongodb-org -y  &>> $LOGFILE
validate $? "$(echo $Y 'Installing mongodb:' $N)" 

systemctl enable mongod &>> $LOGFILE
validate $? "$(echo $Y 'Enabling mongodb:' $N)"

systemctl start mongod  &>> $LOGFILE
validate $? "$(echo $Y 'Starting mongodb:' $N)"

cp /etc/mongod.conf /etc/mongod-$TIMESTAMP.bkp &>> $LOGFILE
validate $? "$(echo -e  $Y 'Copying /etc/mongod file:' $N)"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
validate $? "$(echo -e $Y 'Changing configuration file:' $N)"

systemctl restart mongod  &>> $LOGFILE
validate $? "$(echo $Y 'restarting mongodb:' $N)"


echo -e $R "############################ ADD CATALOGUE SERVER IP IN catalogue.service AND catalogue.sh FILES BEFORE EXECUTING CATALOGUE SCRIPT #########################################" $N
