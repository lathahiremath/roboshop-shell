script=$(realpath "$0")
script_path=$(dirname $"script")

source ${script_path}/common.sh


echo -e "\e[36m>>>>>configuring nodejs repos<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>install Nodejs <<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>Add application user<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>create application directory<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>Download app content<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

cd /app

echo -e "\e[36m>>>>>Unzip app content<<<<<\e[0m"
unzip /tmp/user.zip
cd /app

echo -e "\e[36m>>>>>install Nodejs dependencies<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>create application directory<<<<<\e[0m"
cp $script_path/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>start user service<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user

echo -e "\e[36m>>>>>copy mongodb repo<<<<<\e[0m"
cp $(script_path)/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>install mongodb client<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>load schema<<<<<\e[0m"
mongo --host mongodb-dev.latha.fun </app/schema/user.js