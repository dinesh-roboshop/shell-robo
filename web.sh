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
   echo -e $G " $2 SUCCESS " $N
 else
   echo -e $R " $2 FAILED " $N
   exit 1
 fi 
}

source ./functions.sh
check_root_user

dnf install nginx -y &>> $LOGFILE
validate $? "$(echo -e $Y 'nginx installation:' $N) " 

systemctl enable nginx &>> $LOGFILE
validate $? "$(echo -e $Y 'enabling nginx service:' $N)"

systemctl start nginx &>> $LOGFILE
validate $? "$(echo -e $Y 'starting nginx service:' $N)"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
validate $? "$(echo -e $Y 'removing default content of nginx:' $N)"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE
validate $? "$( echo -e $Y 'Download the frontend content:' $N)"

cd /usr/share/nginx/html; unzip /tmp/web.zip &>>$LOGFILE
validate $? "$( echo -e $Y 'Extracting frontend content:' $N)"

cp /root/office-practice/roboshop.conf /etc/nginx/default.d/  &>>$LOGFILE
validate $? "$( echo -e $Y 'Copying roboshop.conf file:' $N)"

systemctl restart nginx     &>>$LOGFILE
validate $? "$(echo -e $Y 'restarting nginx service:' $N)"
