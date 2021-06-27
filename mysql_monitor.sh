# 监控MySQL，如果没有启动，则启动
# 1.lsof -i tcp:3306|wc -l` -gt 0
# 2. 如下
if [ $(netstat -lntup|grep mysqld|wc -l) -gt 0 ]
then   
    echo "MySQL is Running."
else   
    echo "MySQL is Stopped."    
    systemctl start mysqld
fi

