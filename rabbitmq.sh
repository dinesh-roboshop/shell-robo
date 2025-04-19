#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
MONGO_HOST=mongodb.dineshdevops.shop

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"


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


curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>> $LOGFILE
validate $? "$(echo -e $Y 'configuring yum repo:' $N)"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE
validate $? "$(echo -e $Y 'configuring rabbitmq repo file:' $N)"

dnf install rabbitmq-server -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing Rabbitmq:' $N)"

systemctl enable rabbitmq-server &>> $LOGFILE
validate $? "$(echo -e $Y 'Enabling rabbitmq service:' $N)"

systemctl start rabbitmq-server &>> $LOGFILE
validate $? "$(echo -e $Y 'Starting rabbitmq service:' $N)"


rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE
validate $? "$(echo -e $Y 'Adding user for rabbimq server:' $N)"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE
validate $? "$(echo -e $Y 'Setting permissions for roboshop user:' $N)"
