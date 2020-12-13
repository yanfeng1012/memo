#!/bin/bash

####################################################################################################################
###
### Descipt: this script help us update database more easily 
### Author : HM
### Create : 2020-04-28
### 
### Usage  :
###        1.check update file: when after unzip the tar.gz file, the dir must make like this:
###        [root@localhost fast_update]# ls V008R003M001B0067
###        bin  lib  share
###
###        2.fast_update.sh must in the same dir with the file which need to update,like this:
###        [root@localhost fast_update]# ls
###        fast_update.sh  V008R003M001B0067.tar.gz
###
###        3.execute update:
###        ./fast_update.sh 
###
####################################################################################################################


echo "This tool help use to update database more easily"
echo ""

####################################################################################################################
echo "check the update file is alive:"
update_tar=$(ls *.tar.gz)
if [ $? -ne 0 ]; then
    echo "there is no tar.gz file to update, please check it and try again !"
    echo ""
    exit -1
else
    echo "update file is : "$update_tar
fi
echo ""
####################################################################################################################

echo "get database dir info:"
main_proc_num=$(ps -ef|grep "bin/kingbase"|grep D|wc -l)
if [ $main_proc_num -eq 0 ]; then               
    echo "the database is not on live, please input kingbase home path:"
    read kingbase_home
    if [[ ! -d $kingbase_home ]] || [[ ! -f $kingbase_home/Server/bin/kingbase ]]; then
        echo "kingbase home path is error, please check it and try again !"
        echo ""
        exit
    fi
    server_path=$kingbase_home/Server
    bin_path=$server_path/bin
else
    kingbase_path=$(ps -ef|grep bin/kingbase|grep D|awk '{print $8}')
    bin_path=${kingbase_path%/*}
    server_path=${bin_path%/*}
    kingbase_home=${server_path%/*}
fi
echo "kingbase_path    : "$kingbase_path
echo "server_path      : "$server_path
echo "kingbase_home    : "$kingbase_home
####################################################################################################################

#TODO: we do nothing on data dir !
data_dir=$(ps -ef|grep "bin/kingbase"|grep D|awk '{print $10}')
if [ $data_dir = "." ]; then                                                       
    echo "can not get data path from main process, please input the data path:"
    read data_dir
    if [[ ! -d $data_dir ]] || [[ ! -f $data_dir/kingbase.conf ]]; then
        echo "data path is error"
        echo "you can use: \"find / -name kingbase.conf\" to find it"
        echo "please check and try again !"
        exit -1
    fi
fi
echo "database data_dir: "$data_dir
echo ""
####################################################################################################################

echo "stop the database: "
su - kingbase -c "$bin_path/sys_ctl -D $data_dir -m fast stop"
echo ""
####################################################################################################################

echo "backup server file:"
date_str=$(date "+%Y-%m-%d_%H-%M-%S")
server_back_path=${server_path}_back_$date_str
set -x
mkdir $server_back_path
cp -r $server_path/bin $server_back_path/
cp -r $server_path/lib $server_back_path/
cp -r $server_path/share $server_back_path/
chown -R kingbase:kingbase $server_back_path
set +x
echo ""
####################################################################################################################

echo "unzip the update tar file: "$update_tar
set -x
tar xzvf *.tar.gz  >/dev/null 2>&1
set +x
echo ""
####################################################################################################################

echo "list update dir: "
update_file_path=$(echo $update_tar|cut -d . -f1)
echo "update file path: "$update_file_path
ls -lrth $update_file_path
echo ""
####################################################################################################################

echo "update database file:"
set -x
cp -r $update_file_path/bin $server_path/
cp -r $update_file_path/lib $server_path/
cp -r $update_file_path/share $server_path/
chown -R kingbase:kingbase $server_path
set +x
echo ""
####################################################################################################################

echo "start database:"
su - kingbase -c "$bin_path/sys_ctl -D $data_dir start"
echo ""

echo "update complete"
