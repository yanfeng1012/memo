#!/bin/bash
####################################################################################################################
###
###
####################################################################################################################

####################################################################################################################                                                                                                                                                 
###                                                                                                                                                                                                                                                                  
### Descipt: this tool help us to check rman backup, make sure your backup is correct 
### Author : HM
### Create : 2020-04-28
###
### Usage  : 
###        1.modify the rman.conf file: input correct database conf, like this:
###        kdb_home="/opt/Kingbase/ES/V8/Server/"
###        kdb_data="/opt/Kingbase/ES/V8/data"
###        kdb_user="SYSTEM"
###        kdb_pass="system"
###        kdb_port="54323"
###        kdb_host="127.0.0.1"
###        kdbback_dest="/data/kingbase/backup"
###        keep_num="2"
###
###        2.execute check:
###        ./rman_check.sh
###
####################################################################################################################

conf_file=$(dirname $(readlink -f "$0"))"/rman.conf"
echo "conf file is: $conf_file"
#source $conf_file

kdb_home=`cat $conf_file |grep kdb_home|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_data=`cat $conf_file |grep kdb_data|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_user=`cat $conf_file |grep kdb_user|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_pass=`cat $conf_file |grep kdb_pass|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_port=`cat $conf_file |grep kdb_port|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_host=`cat $conf_file |grep kdb_host|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdbback_dest=`cat $conf_file |grep kdbback_dest|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdbarchive_dest=`cat $conf_file |grep kdbarchive_dest|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
keep_num=`cat $conf_file |grep keep_num|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`

LD_LIBRARY_PATH="${kdb_home}/lib"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH

echo "This tool help use to check kingbase database's rman backup file, must execute in local server"
echo ""

echo "$(date '+%Y-%m-%d %H:%M:%S') : check begin"

if [ ! -d ${kdbback_dest} ]; then
    echo "kdbback_dest: $kdbback_dest is not exist, please check the rman.conf file and try again !"
    exit
fi
echo "kdbback_dest : $kdbback_dest is correct"

if [ ! -f ${kdbback_dest}/sys_rman.conf ] ;then
    echo "kdbback_dest: $kdbback_dest is not rman path, please check the rman.conf file and try again !"
    exit
fi
echo ""

echo "1.check database status:"
${kdb_home}/bin/ksql -h ${kdb_host} -p ${kdb_port} -U ${kdb_user} -W ${kdb_pass}  -c "select now();" TEMPLATE2 > /dev/null 2>&1
if [ $? -ne 0 ] ;then
    echo -e "database is not running, please check it !" 
    ###TODO: don't care about database status, we just check rman backup
else
    echo -e "database is running" 
fi
echo ""

echo "2.show kingbase rman backup list:"
${kdb_home}/bin/sys_rman show -B ${kdbback_dest}
echo ""

echo "3.check every backup ID:"
backup_list=$($kdb_home/bin/sys_rman show -B $kdbback_dest|grep -v -E "===|ID"|awk '{print $1}')
for backup_ID in $backup_list;
do 
    echo "---------------------------------------------------------"
    echo "check backup ID: " $backup_ID
    $kdb_home/bin/sys_rman validate $backup_ID -B $kdbback_dest
done
echo "---------------------------------------------------------"

echo "$(date '+%Y-%m-%d %H:%M:%S') : check end"
##### end
exit 0
