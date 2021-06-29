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