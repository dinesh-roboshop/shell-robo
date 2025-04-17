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


## primary RabbitMQ signing key
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc' &>> $LOGFILE
validate $? "$(echo -e $Y 'Importing primary RabbitMQ signing key :' $N)"
## modern Erlang repository
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key' &>> $LOGFILE
validate $? "$(echo -e $Y 'Importing moderen Erland repository :' $N)"
## RabbitMQ server repository
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key' &>> $LOGFILE
validate $? "$(echo -e $Y 'Importing RabbitMQ server repository :' $N)"

cp /root/office-practice/rabbitmq.repo /etc/yum.repos.d/ &>> $LOGFILE
validate $? "$(echo -e $Y 'Copying rabbitmq.repo file:' $N)"

dnf update -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Updating yum:' $N)"

## install these dependencies from standard OS repositories
dnf install -y logrotate &>> $LOGFILE
validate $? "$(echo -e $Y 'Install these dependencies from standard OS repositories:' $N)"

## install RabbitMQ and zero dependency Erlang
dnf install -y erlang rabbitmq-server &>> $LOGFILE
validate $? "$(echo -e $Y 'Install RabbitMQ and zero dependency Erlang:' $N)"

systemctl enable rabbitmq-server &>> $LOGFILE
validate $? "$(echo -e $Y 'Enabling rabbitmq service:' $N)"

systemctl start rabbitmq-server &>> $LOGFILE
validate $? "$(echo -e $Y 'Starting rabbitmq service:' $N)"


rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE
validate $? "$(echo -e $Y 'Adding user for rabbimq server:' $N)"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE
validate $? "$(echo -e $Y 'Setting permissions for roboshop user:' $N)"
