script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "setup mongodb repo"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_stat_check $?

func_print_head "Install mongodb"
yum install mongodb-org -y &>>$log_file
func_stat_check $?

func_print_head "update mongodb listen adress"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
func_stat_check $?

func_print_head "start mongodb"
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
func_stat_check $?
#edit the file with 127.0.0.0 with 0.0.0.0
