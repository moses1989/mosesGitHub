#!/bin/sh  
#export PS4='[$0 | $LINENO]+++ '
#set -x


#公共函数
function configFile()
{
    if [ -z $3 ];then
        grep -e "^$1$" "$2"
    else
        grep -e "^$3$" "$2"
    fi

    if [ 0 -ne $? ];then
        if [ -f $2 ];then
            echo "$1" >> "$2"
        else
            echo "ERROR: $2 is not a file"
        fi
    fi
}

#原创者
function OWNER()
{
cat << MOSES
     ___  ___     _____       _____                         
    /  / /  /____/ ____/_____/ ____/      ___  _________    
   /   \/  /  _  \ \___/  __ \ \___      /   \/   /  __  \  
  /  /\_/ /  /_/ /\___ \   __/\___ \ _  /  /__/  /  /_/  /  
 /__/  /_/\ ____//_____/\___//_____/(_)/__/  /__/ \_____/   
MOSES
}
 
#拷贝安装包
function INSTALL()
{
    expect << EXPECT
set timeout 20
spawn rsync vbox@chivbox2:~/fpgdebug/* / -av
expect "password:"
send "vbox\r"
expect eof
EXPECT
    
    if [ 0 -ne $? ];then
        echo "ERROR: Install rsync failed."
    else
        echo "INFO: Install rsync successfully."
    fi

}

#安装插件
function PLUGINS()
{
    sudo sh ./PluginsInstall.sh
	
    if [ 0 -ne $? ];then
        echo "ERROR: Install plugins failed."
    else
        echo "INFO: Install plugins successfully."
    fi

}


#所有操作
function ALL()
{
    INSTALL
    PLUGINS
}

#用户权限
OWNER
IS_ROOT=`who | grep root`
CHECK_ROOT_NUM=0
until [ "$IS_ROOT" ]
do
    sleep 5
    if [ 5 -ne $CHECK_ROOT_NUM ];then
        exit
    else
        IS_ROOT=`who | grep root`
        let CHECK_ROOT_NUM++
    fi
done
echo "INFO: Root is in" 
 
#主选项
PS3="Select a number(1-4):"
select step in INSTALL PLUGINS ALL EXIT
do
    case $step in
        INSTALL) INSTALL
        ;;
        PLUGINS) PLUGINS
        ;;
        ALL) ALL
        ;;
        EXIT) exit
        ;;
        *) echo "ERROR: Invalid selection"
        ;;
    esac
done

