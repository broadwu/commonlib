# 判断输入是否为整数

function isdigit() {
    if [[ ! $1 =~ ^[[:digit:]]+$ ]]; then
      echo 1
    else
      echo 0
    fi
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
