# 判断输入是否为整数

function isdigit() {
    if [[ ! $1 =~ ^[[:digit:]]+$ ]]; then
      echo 1
    else
      echo 0
    fi
}
