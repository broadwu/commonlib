#! /bin/bash
# chkconfig: 2345 20 80
# description: Rsyncd Startup scripts by oldboy .
. /etc/init.d/functions
function usage() {
    echo $"usage:$0 {start|stop|restart}"
    exit 1
}
function start() {
    rsync --daemon
    sleep 1
    if [ "$(netstat -lntup|grep rsync|wc -l)" -ge 1 ]
    then
        action "rsyncd is started." /bin/true
    else
        action "rsyncd is started." /bin/false
    fi
}

function stop(){
    killall rsync &> /dev/null
    sleep 2
    if [ "$(netstat -lntup|grep rsync|wc -l)" -eq 0 ]
    then
        action "rsyncd is stopped." /bin/true
    else
        action "rsyncd is started." /bin/false
    fi
}

function main() {
    if [ $# -ne 1 ]
    then
        usage 
    fi
    if [ "$1" = "start" ]
    then
        start
    elif [ "$1" = "stop" ]
    then
        stop
    elif [ "$1" = "restart" ]
    then
        stop
        sleep 1
        start
    else
        usage
    fi
}
main $*