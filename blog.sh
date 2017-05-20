#!/bin/bash
# author:bezhi
# url:https://github.com/otale/scripts


env_args="-Xms128m -Xmx128m"
sleeptime=0
arglen=$#

# get blog pid
get_pid(){
    pname="`find .. -name 'blog*.jar'`"
    pname=${pname:3}
    pid=`ps -ef | grep $pname | grep -v grep | awk '{print $2}'`
    echo "$pid"
}

startup(){
    pid=$(get_pid)
    if [ "$pid" != "" ]
    then
        echo "Blog already startup!"
    else
        jar_path=`find .. -name 'blog*.jar'`
        echo "jarfile=$jar_path"
        cmd="java $1 -jar $jar_path > ./blog.out < /dev/null &"
        echo "cmd: $cmd"
        java $1 -jar $jar_path > ./blog.out < /dev/null &
        show_log
    fi
}

shut_down(){
    pid=$(get_pid)
    if [ "$pid" != "" ]
    then
        kill -9 $pid
        echo "Blog is stop!"
    else
        echo "Blog already stop!"
    fi
}

show_log(){
    tail -f blog.out
}

show_help(){
    echo -e "\r\n\t欢迎使用Blog"
    echo -e "\r\nUsage: sh blog.sh start|stop|reload|status|log"
    exit
}

show_status(){
    pid=$(get_pid)
    if [ "$pid" != "" ]
    then
        echo "Blog is running with pid: $pid"
    else
        echo "Blog is stop!"
    fi
}

if [ $arglen -eq 0 ]
 then
    show_help
else
    if [ "$2" != "" ]
    then
        env_args="$2"
    fi
    case "$1" in
        "start")
            startup "$env_args"
            ;;
        "stop")
            shut_down
            ;;
        "reload")
            echo "reload"
            ;;
        "status")
            show_status
            ;;
        "log")
            show_log
            ;;
    esac
fi