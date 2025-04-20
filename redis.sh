#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-TIMESTAMP.log"
LOCATION="/root/shell-robo"


validate ( ) {
if [ $1 -eq 0 ]
then
   echo -e $2 $G "SUCEESS" $N
else
   echo -e $2 $R "FAILED" $N
   exit 1
fi
}

source ./functions.sh

check_root_user

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.4.rpm -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing redis repository:' $N)"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Enabling redis 6.2 from package stream:' $N)"

dnf install -y redis &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing redis package:' $N)"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf  &>> $LOGFILE
validate $? "$(echo -e $Y 'Modifying redis configuration file /etc/redis.conf:' $N)"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf  &>> $LOGFILE
validate $? "$(echo -e $Y 'Modifying redis configuration file/etc/redis/redis.conf:' $N)"

systemctl enable redis  &>> $LOGFILE
validate $? "$(echo -e $Y 'Enabling redis service:' $N)"

systemctl start redis  &>> $LOGFILE
validate $? "$(echo -e $Y 'Starting redis service:' $N)"
