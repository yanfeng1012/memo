#!/bin/bash

####################################################################################################################                                                                                                                                                 
###                                                                                                                                                                                                                                                                  
### Descipt: this tool help us to collect local kingbase or cluster log, make troubleshooting more easiy  
### Author : HM
### Create : 2020-04-30
###
### Usage  :
###        ./kb_log_collector.sh kingbase_data_path
###
####################################################################################################################


echo "This tool help use to collect local kingbase or cluster log, make troubleshooting more easiy"
echo ""

if [ $# -ne 1 ];then
    echo "Usage:"
    echo "kb_log_collector.sh kingbase_data_path"
    echo ""
    exit
else
    if [[ ! -d $1 ]] || [[ ! -f $1/kingbase.conf ]]; then
        echo "\"$1\" is not a kingbase data path, please check and try again !"
        exit
    fi
fi


date_str=$(date "+%Y-%m-%d_%H-%M-%S")
current_path=$PWD

data_path=$1
log_path=$data_path/sys_log
if [ ! -d $log_path ]; then
    echo "the log path is not exist, please input the sys_log path:"
    read log_path
    if [ ! -d $log_path ]; then
        echo "the log path is error, please make sure and try again ! "
        exit
    fi
fi

echo "check log dest path:"
log_dest="database_log_$date_str"
if [ ! -d $log_dest ]; then
    echo "create dir: $log_dest"
    mkdir $log_dest
fi
echo ""

echo "1.collect system messages:"
sys_msg=/var/log/messages
if [ -f $sys_msg ]; then
    cp $sys_msg $log_dest/"messages"
    echo "copyed $sys_msg  to "$PWD$
else
    echo "$sys_msg is not exist, ignore"
fi
echo ""

echo "2.collect last five kingbase log from $log_path:"
cd $log_path
csv_log_count=$(ls |grep csv|wc -l)
if [ $csv_log_count -gt 0 ]; then
    echo "log type: csv"
    logfiles=$(ls -rlth|tail -n 10|awk '{print $9}'|grep csv)
else
    echo "log type: log"
    logfiles=$(ls -rlth|tail -n 5|awk '{print $9}'|grep log)
fi

tar_str="tar czvf database_log.tar.gz"
for file in $logfiles; 
do
    tar_str=$(echo "$tar_str $file") 
done
$(echo $tar_str)
mv database_log.tar.gz $current_path/$log_dest/
echo ""
cd $current_path


echo "3.collect kingbase.conf:"
cp $data_path/kingbase.conf  $log_dest/kingbase.conf
echo "cp kingbase.conf to $log_dest"
echo ""

echo "4.collect database log sucess, tar those log file:"
cd $log_dest
tar czvf database_log_$date_str.tar.gz *
cd $current_path
echo ""

echo "log file list:"
ls -rlth $log_dest
echo ""
