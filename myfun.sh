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
