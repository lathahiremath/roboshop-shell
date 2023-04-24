script=$(realpath "$0")
script_path=$(dirname $"script")
source ${script_path}/common.sh

if [ -z "$mysql_root_password" ];then
  echo input mysql_root_password missing
fi

echo -e "\e[36m>>>>>disable mysql 8 version<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>copy mysql repo file<<<<<\e[0m"
cp $(script_path)/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>Install Mysql<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[36m>>>>>Start mysql<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[36m>>>>>Reset mysql password<<<<<\e[0m"
mysql_secure_installation --set-root-pass $mysql_root_password