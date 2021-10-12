# 判断输入是否为整数

function isdigit() {
    if [[ ! $1 =~ ^[[:digit:]]+$ ]]; then
      echo 1
    else
      echo 0
    fi
}

# 判断输入是否为字符
function isalpha ()  # Tests whether *first character* of input string is alphabetic.
{
if [ -z "$1" ]                # No argument passed?
then
  return $FAILURE
fi

case "$1" in
  [a-zA-Z]*) return $SUCCESS;;  # Begins with a letter?
  *        ) return $FAILURE;;
esac
}


# 判断URL是否有效

function check_url() {
    wget --spider -q -o /dev/null --tries=1 -T 5 $1 
    if [ $? -eq 0 ]      
    then        
	echo "$1 is yes."    
    else        
	echo "$1 is no."    
    fi
}

# 监控MySQL，如果没有启动，则启动
# 1.lsof -i tcp:3306|wc -l` -gt 0
# 2. 系统CentOS,如下
function check_mysqld(){
    if [ $(netstat -lntup|grep mysqld|wc -l) -gt 0 ]
    then   
        echo "MySQL is Running."
    else   
        echo "MySQL is Stopped."    
        systemctl start mysqld
    fi
}

# 设置每五分钟同步一次时间
function time_update() {
    host="server 210.72.145.44 iburst\nserver ntp.aliyun.com iburst"
    cron=/var/spool/cron/root
    sed -i -e 's/.*iburst/#&/' -e  "/.*iburst/a$host" /etc/chrony.conf
    systemctl restart chronyd.service
    chronyc sources -v

    echo "#time sync at $(date +%F-%H:%M)" >> $cron
    echo "*/5 * * * * /usr/bin/chronyc sources -v > /dev/null 2>&1" >> $cron
    crontab -l
}

# 获取随机数
function get_a_number() {
    num=$(awk -v num="$1" 'BEGIN{ srand(); print rand() * num}')
    echo $num | awk -F. '{print $1}'
}

# 生成随机字符串
function gen_a_string() {
	echo $(echo test$RANDOM|md5sum|cut -c $1-$2)
}

# 输出报错信息
function print_error_info(){
    echo -e "\033[31m $1 \033[0m"
}

# 输出成功信息
function print_success_info(){
    echo -e "\033[32m $1 \033[0m"
}

# 去除头尾的空格
trim_string() {
    # Usage: trim_string "   example   string    "
    : "${1#"${1%%[^[:space:]]*}"}"
    : "${_%"${_##*[^[:space:]]}"}"
    printf '%s\n' "$_"
}

# 本机免密自动化脚本，需要安装expect
function set_free_access() {
    ips=(127.0.0.2 127.0.0.3 127.0.0.4)
    rm -rf /root/.ssh/id_rsa*

    expect -c "
        spawn ssh-keygen
        expect {
            \"(/root/.ssh/id_rsa):\" {send \"\r\"; exp_continue}
            \"empty for no passphrase):\" {send \"\r\"; exp_continue}
            \"passphrase again:\" {send \"\r\"; exp_continue}
            }
        "
    for ip in ${ips[*]}
    do
        expect -c "
            spawn ssh-copy-id $ip
            expect {
                \"yes/no\" {send \"yes\r\"; exp_continue}
                \"password:\" {send \"password\r\"; exp_continue}
            }
        "
    done
}

# 通过名称杀掉进程
# Warning:
#  -------
#  This is a fairly dangerous script.
#  Running it carelessly (especially as root)
#+ can cause data loss and other undesirable effects.
function kill_by_name() {
	E_BADARGS=66

	if test -z "$1"  # No command-line arg supplied?
	then
	  echo "Usage: `basename $0` Process(es)_to_kill"
	  exit $E_BADARGS
	fi


	PROCESS_NAME="$1"
	ps ax | grep "$PROCESS_NAME" | awk '{print $1}' | xargs -i kill {} 2&>/dev/null
	exit $?
}
