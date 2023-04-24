app_user=roboshop

script=$(realpath "$0")
script_path=$(dirname $"script")

func_print_head()
{
  echo -e "\e[36m>>>>>$1<<<<<\e[0m"
}

func_schema_setup()
{
  if[ "schema_setup" == "mongo"]; then
   func_print_head copy mongodb repo
   cp $(script_path)/mongo.repo /etc/yum.repos.d/mongo.repo

  func_print_head install mongodb client
  yum install mongodb-org-shell -y

  func_print_head load schema
  mongo --host mongodb-dev.latha.fun </app/schema/${component}.js
 }

func_nodejs() {
print_head "configuring nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_head "install Nodejs"
yum install nodejs -y

print_head "Add application user"
useradd ${app_user}

print_head "create application directory"
rm -rf /app
mkdir /app

print_head "Download app content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

cd /app

print_head "Unzip app content"
unzip /tmp/${component}.zip
cd /app

print_head "install Nodejs dependencies"
npm install

print_head "create application directory"
cp $(script_path)/${component}.service /etc/systemd/system/${component}.service

print_head "start cart service"
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component}
func_schema_setup
}

func_java()
{
  print_head "Install maven"
  yum install maven -y

  print_head "create app user"
  useradd ${app_user}

  print_head "Create app directory"
  rm -rf /app
  mkdir /app

  print_head "download app content"
  curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

  print_head "extract app content"
  cd /app
  unzip /tmp/shipping.zip

  print_head "download maven dependencies"
  mvn clean package
  mv target/shipping-1.0.jar shipping.jar

  print_head "install mysql client"
  yum install mysql -y

  print_head "load schema"
  mysql -h mysql-dev.latha.fun -uroot -p${mysql_root_password} < /app/schema/shipping.sql

  cp $(script_path)/shipping.service /etc/systemd/system/shipping.service

  print_head "start shipping service"
  systemctl daemon-reload
  systemctl enable shipping
  systemctl restart shipping


}}