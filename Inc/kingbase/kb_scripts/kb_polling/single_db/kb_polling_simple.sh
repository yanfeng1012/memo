#!/bin/bash

conf_file=$(dirname $(readlink -f "$0"))"/polling.conf"
echo "conf file is: $conf_file"
source $conf_file

#db_port=54323
#db_user=SYSTEM
#db_password=system
#db_name=TEST

db_port=`cat $conf_file |grep db_port|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
db_user=`cat $conf_file |grep db_user|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
db_password=`cat $conf_file |grep db_password|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
db_name=`cat $conf_file |grep db_name|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
db_version=`cat $conf_file |grep db_version|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
if [ ! $db_version ]; then
    db_version="R3"
fi
echo "db_version is: $db_version"

date_str=$(date "+%Y-%m-%d_%H-%M-%S")

echo "please chose polling output mode: 
0           : to log file
1 or other  : to console"

read output_option
if [ $output_option -eq 0 ]; then
    polling_log="kb_polling_${db_port}_${db_user}_${db_name}_$date_str.log"
    echo "polling log is: $polling_log"
    ./kb_polling.sh $db_port $db_user $db_password $db_name $db_version >./$polling_log 2>&1
else
    ./kb_polling.sh $db_port $db_user $db_password $db_name $db_version
fi
