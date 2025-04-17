#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-TIMESTAMP.log"


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

#dnf install -y epel-release &>> $LOGFILE
#validate $? "$(echo -e $Y 'Installing epel-release repository:' $N)"

dnf install -y redis6 &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing redis package:' $N)"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis6/redis6.conf  &>> $LOGFILE
validate $? "$(echo -e $Y 'Modifying redis configuration file:' $N)"

systemctl enable redis6  &>> $LOGFILE
validate $? "$(echo -e $Y 'Enabling redis service:' $N)"

systemctl start redis6  &>> $LOGFILE
validate $? "$(echo -e $Y 'Starting redis service:' $N)"
