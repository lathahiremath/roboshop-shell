echo -e "\e[36m>>>>>configuring nodejs repos<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>install Nodejs <<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>Add application user<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>create application directory<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>Download app content<<<<<<\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip

cd /app

echo -e "\e[36m>>>>>Unzip app content<<<<<\e[0m"
unzip /tmp/cart.zip
cd /app

echo -e "\e[36m>>>>>install Nodejs dependencies<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>create application directory<<<<<\e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m>>>>>start cart service<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart
