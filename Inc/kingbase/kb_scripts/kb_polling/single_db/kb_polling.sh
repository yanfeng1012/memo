#!/bin/bash

####################################################################################################################                                                                                                                                                 
###                                                                                                                                                                                                                                                                  
### Descipt: this tool help us to make a database poling 
### Author : HM
### Create : 2020-04-28
###
### Usage  :
###        ./kb_polling.sh db_port db_user db_password db_name
###
####################################################################################################################


echo "This tool help use to make a database polling, must execute in local server"
echo ""

if [ $# -eq 5 ]; then
	db_port=$1
	db_user=$2
	db_pwrd=$3
	db_name=$4
	db_version=$5
else
	echo "the parameter is error, please check again !"
	echo "Usage:"
	echo "kb_polling db_port db_user db_password db_name"
	echo ""
	exit
fi

echo "kingbase database polling begin : $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

main_proc_num=$(ps -ef|grep "bin/kingbase"|grep D|wc -l)
if [ $main_proc_num -eq 0 ]; then
	echo "the database is not on live, please check it !!!"
	echo ""
	exit
fi

#kingbase_path=$(ps -ef|grep "Server/bin/kingbase"|grep D|awk '{print $8}'|tail -n 1)
kingbase_path=$(ps -ef|grep "bin/kingbase"|grep D|awk '{print $8}'|tail -n 1)
bin_path=${kingbase_path%/*}
server_path=${bin_path%/*}
install_path=${server_path%/*}
db_conn=$(echo $bin_path/ksql -At  -p $db_port -U $db_user -W $db_pwrd -d $db_name)
db_conn_noAt=$(echo $bin_path/ksql -p $db_port -U $db_user -W $db_pwrd -d $db_name)
#echo $db_conn

if [ $db_version = "R6" ]; then
    #create .kbpass file if not exist:
    kbpass="${HOME}/.kbpass"
    if  [ ! -f $kbpass ] ; then
        echo "*:*:*:$db_user:$db_pwrd" > $kbpass
        chmod 600 $kbpass
    fi

    #R6 can not use -W to config password
    db_conn=$(echo $bin_path/ksql -At -p $db_port -U $db_user -d $db_name)
    db_conn_noAt=$(echo $bin_path/ksql -p $db_port -U $db_user -d $db_name)
fi

$db_conn_noAt -c "select now();" > /dev/null 2>&1
if [ $? -ne 0 ] ;then
	echo "the database is not on live, please check it !!!"
	echo "database connection info is: "
	echo ""$db_conn_noAt
	echo ""
    exit 1
else
    echo "database status    : running"
fi



echo "database info      :"
echo "database bin_path  :  "$bin_path

data_dir=$(ps -ef|grep "bin/kingbase"|grep D|awk '{print $10}')
if [ $data_dir = "." ]; then
    #echo "can not get data path from main process, now get it from database"
    data_dir=$($db_conn -c "show data_directory;")
fi
echo "database data_dir  :  "$data_dir

db_version=$($db_conn -c "select version()")
echo "database version   :  "$db_version

case_sensitive=$($db_conn -c "show case_sensitive")
echo "database sensitive : " $case_sensitive
echo "DB PORT            : " $db_port

main_proc_pid=$(ps -ef|grep kingbase|grep data|grep D|awk '{print $2}')
echo "database main_pid  : " $main_proc_pid
echo ""

echo "1.System Information:"
echo "----------------------------------------------------------------------------"
echo ">>>get IP info:"
ifconfig|grep inet|grep -i Mask|sed 's/^[ \t]*//g' 
echo ""
echo "HWaddr:"
ifconfig|grep HWaddr
echo ""

echo ">>>get CPU info:"
lscpu |grep -E "Architecture|op-mode|CPU|per"
echo ""

echo ">>>get Disk info:"
df -h
echo ""
echo "database data dir usage:"
echo "uage: "$(du -sh $data_dir)
echo "disk: "$(df -h $data_dir)
echo ""

echo ">>>get Mem info:"
free -g
echo "----------------------------------------------------------------------------"
echo ""

echo ">>>runtime load:"
echo "iostat:"
iostat -dcx 5 3
echo ""

echo "vmstat:"
vmstat -a -S M 5 3
echo ""
echo "prints disk table:"
vmstat -D
echo ""

echo "top 10 cpu cost process:"
ps aux|head -1;ps aux|grep -v -E "PID|ps aux|sort -rn"|sort -rn -k +3|head
echo ""

echo "top 10 memory cost process:"
ps aux|head -1;ps aux|grep -v -E "PID|ps aux|sort -rn"|sort -rn -k +4|head
echo ""


echo "2.System Optimize info:"
echo "----------------------------------------------------------------------------"
echo ">>>sysctl importent config:"
sysctl -a|grep -i -E "kernel.sem|kernel.shmall|kernel.shmmax|kernel.shmmni|vm.dirty_background_ratio|vm.dirty_ratio|vm.overcommit_memory|vm.overcommit_ratio|vm.swappiness"
echo ""

echo ">>>limit config:"
cat /etc/security/limits.conf|grep -v -E "^#|^$"
cat /etc/security/limits.d/* |grep -v -E "^#|^$"
echo ""

echo ">>>SELINUX:"
cat /etc/selinux/config|grep SELINUX=|grep -v "^#"
echo ""
echo ">>>scheduler:"
cat /etc/rc.d/rc.local|grep scheduler
echo ""

echo ">>>firewalld status:"
which service >/dev/null  2>&1 
if [ $? -eq 0 ];then
	service iptables status
else
	systemctl status firewalld
fi
echo ""

#systemver=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`
#if [[ $systemver = "6" ]];then
#	service iptables status
#else 
#	systemctl status firewalld
#fi
#echo "----------------------------------------------------------------------------"
#echo ""


echo "3.Database Information:"
echo "----------------------------------------------------------------------------"
echo ">>>database size: "
$db_conn_noAt -c "select datname, encoding, datctype, datfrozenxid, sys_size_pretty(sys_database_size(datname)) db_size from sys_database 
where upper(datname) not in ('TEMPLATE0', 'TEMPLATE1', 'TEMPLATE2', 'SAMPLES') order by db_size desc;"
echo ""

echo ">>>table space size: "
$db_conn_noAt -c "select spcname, sys_size_pretty(sys_tablespace_size(spcname)) as tbspc_size from sys_tablespace where upper(spcname) not in ('SYS_GLOBAL');"
echo ""

db_connection=$($db_conn -c "select count(*) -1 from sys_stat_activity;") 
echo -e ">>>database activity connections: " $db_connection
echo ""

echo "current connection wait info: "
$db_conn_noAt -c "select wait_event_type, wait_event, state, count(*) from sys_stat_activity group by wait_event_type, wait_event, state;"
echo ""

#TODO: add long transaction connection:

db_locks=$($db_conn -c "select count(*) from sys_locks;")
echo ">>>database lock count: " $db_locks 
echo ""

echo "lock failed list:"
$db_conn_noAt -c "select locktype, database, relation, pid, granted from sys_locks where granted = false;"
echo ""

#if the table name is case_insensitive, this sql will failed, just ignore it!
echo ">>>top 10 table info:"
$db_conn_noAt -c "select SCHEMANAME, u.RELNAME, SEQ_SCAN, IDX_SCAN,  
IDX_SCAN/(IDX_SCAN + SEQ_SCAN +1)*100 idx_scn_rate,
N_TUP_HOT_UPD, N_LIVE_TUP, N_DEAD_TUP, 
N_DEAD_TUP/(N_LIVE_TUP + N_DEAD_TUP + 1)*100 exp_rate, 
sys_size_pretty(sys_relation_size(u.relname::regclass)) table_size, 
sys_size_pretty(sys_indexes_size(u.relname::regclass)) indexes_size, 
sys_relation_filepath(u.relname::regclass) file_path,
age(RELFROZENXID) age
from sys_stat_user_tables u 
left join sys_class c on u.relname = c.relname 
where schemaname not in ('SYS_HM', 'SYSAUDIT', 'SYSLOGICAL', 'SYSLOGICAL', 'sysmac', 'sys') 
order by N_LIVE_TUP desc limit 10;"

echo ""


#echo "top 10 table other info:"
#$db_conn_noAt -c "select RELNAME, NSPNAME, RELTYPE, RELTABLESPACE, RELPAGES, RELTUPLES, RELALLVISIBLE, 
#sys_relation_filepath(relname::regclass), 
#RELFROZENXID, age(RELFROZENXID) 
#from sys_class c left join sys_namespace n on c.relnamespace = n.OID
#where NSPNAME not in ('SYS_TOAST', 'SYS_HM', 'SYSLOGICAL', 'SYSAUDIT', 'SYS_CATALOG', 'INFORMATION_SCHEMA') order by RELTUPLES desc limit 10;"
#echo ""

echo ">>>license info::"
echo "license path is: " $install_path/license.dat
#cat $install_path/license.dat |grep -E "生产日期|产品名称|产品版本号|浮动基准日期|有效期间"
tail -n 19 $install_path/license.dat 
echo ""
echo "current HWaddr:"
ifconfig|grep HWaddr
echo ""

echo ">>>backup job:"
crontab -l
echo ""

echo ">>>DB config:"
cat $data_dir/kingbase.conf|grep -v -E "^#|^$|^\s+"
echo ""
echo "----------------------------------------------------------------------------"
echo "kingbase database polling end : $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
