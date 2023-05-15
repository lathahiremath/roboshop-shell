script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

if [ -z "$mysql_root_password" ];then
  echo input mysql_root_password missing
fi

func_print_head "Disable mysql 8 version"
dnf module disable mysql -y &>>$log_file
func_stat_check $?

func_print_head "copy mysql repo file"
cp $(script_path)/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_stat_check $?

func_print_head "install mysql"
yum install mysql-community-server -y &>>$log_file
func_stat_check $?

func_print_head "start mysql"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
func_stat_check $?

func_print_head "reset mysql passsword"
mysql_secure_installation --set-root-pass $mysql_root_password &>>$log_file
func_stat_check $?