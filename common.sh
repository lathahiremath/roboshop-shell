app_user=roboshop

script=$(realpath "$0")
script_path=$(dirname $"script")

func_print_head()
{
  echo -e "\e[36m>>>>>$1<<<<<\e[0m"
}

func_schema_setup()
{
  if [ "schema_setup" == "mongo" ]; then
   func_print_head copy mongodb repo
   cp $(script_path)/mongo.repo /etc/yum.repos.d/mongo.repo

   func_print_head install mongodb client
   yum install mongodb-org-shell -y

   func_print_head load schema
   mongo --host mongodb-dev.latha.fun </app/schema/${component}.js
  fi

  if [ "schema_setup" == "mysql" ]; then

      func_print_head "install mysql client"
      yum install mysql -y

      func_print_head "load schema"
      mysql -h mysql-dev.latha.fun -uroot -p${mysql_root_password} < /app/schema/${component}.sql
  fi
 }

func_app_prereq()
{
func_print_head "Add application user"
useradd ${app_user}

func_print_head "create application directory"
rm -rf /app
mkdir /app

func_print_head "Download application content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

cd /app

func_print_head "Unzip application content"
unzip /tmp/${component}.zip
cd /app
}

func_systemd_setup()
{
  func_print_head "copy systemD service"
  cp $(script_path)/${component}.service /etc/systemd/system/${component}.service

    func_print_head "start ${component} service"
    systemctl daemon-reload
    systemctl enable ${component}
    systemctl restart ${component}

}
func_nodejs() {
func_print_head "configuring nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

func_print_head "install Nodejs"
yum install nodejs -y

func_app_prereq

func_print_head "install Nodejs dependencies"
npm install

func_systemd_setup
func_schema_setup
}

func_java()
{
  func_print_head "Install maven"
  yum install maven -y

  func_app_prereq


  func_print_head "download maven dependencies"
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar


  func_systemd_setup

}