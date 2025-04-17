#!/bin/bash

app_configure ( ) {

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

curl -o /tmp/$COMPONENT.zip https://roboshop-builds.s3.amazonaws.com/$COMPONENT.zip  &>> $LOGFILE
validate $? "$(echo -e $Y 'Downloading $COMPONENT code:' $N)"

cd /app &>> $LOGFILE
validate $? "$(echo -e $Y 'Switching to /app directory:' $N)"

unzip /tmp/$COMPONENT.zip &>> $LOGFILE
validate $? "$(echo -e $Y 'Extracting code to /tmp:' $N)"

cd /app &>> $LOGFILE
validate $? "$(echo -e $Y 'Switching to /app directory:' $N)"

} 

service_configure ( ) {

cp /root/office-practice/$COMPONENT.service  /etc/systemd/system/ &>> $LOGFILE
validate $? "$(echo -e $Y 'Creatomg $COMPONENT systemd file:' $N)"

systemctl daemon-reload &>> $LOGFILE
validate $? "$(echo -e $Y 'Reloading systemd:' $N)"

systemctl enable $COMPONENT  &>> $LOGFILE
validate $? "$(echo -e $Y 'Enabling $COMPONENT  service:' $N)"

systemctl start $COMPONENT &>> $LOGFILE
validate $? "$(echo -e $Y 'Starting $COMPONENT  service:' $N)"

}
