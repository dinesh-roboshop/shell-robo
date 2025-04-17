#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
MONGO_HOST=13.218.81.249
COMPONENT=shipping

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

dnf install maven -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing maven:' $N)"

app_configure

mvn clean package &>> $LOGFILE
validate $? "$(echo -e $Y 'Compiling application package:' $N)"

mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE
validate $? "$(echo -e $Y 'Renaming the package:' $N)"

service_configure

dnf install mysql -y &>> $LOGFILE
validate $? "$(echo -e $Y 'Installing mysql client:' $N)"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOGFILE
validate $? "$(echo -e $Y 'Loading schema:' $N)"

systemctl restart shipping &>> $LOGFILE
validate $? "$(echo -e $Y 'Restarting mysql service:' $N)"




