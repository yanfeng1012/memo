
#!/bin/bash

####################################################################################################################                                                                                                                                                 
###                                                                                                                                                                                                                                                                  
### Descipt: this script help us to check our logical dump file 
### Author : HM
### Create : 2020-04-28
###
### Usage  :
###        1.modify the backup8.conf file: input correct database conf, like this:
###        kdb_home=/opt/Kingbase/ES/V8/Server
###        kdbback_dest = /data/kingbase/dump/
###        kdb_user=SYSTEM
###        kdb_pass=system
###        kdb_port=54323
###        kdb_host=127.0.0.1
###        kdb_list = TEST,SAMPLES
###        keep_time = 7
###
###        2.execute check:
##         ./backup8_check.sh
##         ./backup8_check.sh latest
###
####################################################################################################################


#load the backup confuration
conf_file=$(dirname $(readlink -f "$0"))"/backup8.conf"
echo "conf file is: $conf_file"
source $conf_file

####################### variable define ##########################
kdb_home=`cat $conf_file |grep kdb_home|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdbback_dest=`cat $conf_file |grep kdbback_dest|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_user=`cat $conf_file |grep kdb_user|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_pass=`cat $conf_file |grep kdb_pass|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_port=`cat $conf_file |grep kdb_port|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_host=`cat $conf_file |grep kdb_host|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_list=`cat $conf_file |grep kdb_list|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
keep_time=`cat $conf_file |grep keep_time|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`

echo "This tool help us to check our logical dump file"
echo ""

if [[ $# -eq 1 ]] && [[ $1 = "-h" ]] || [[ $1 = "--help" ]];then
    echo "Usage:"
    echo "1.check all dump file:"
    echo "  ./backup8_check.sh "
    echo ""
    echo "2.check the latest dump file for every database:"
    echo "  ./backup8_check.sh latest"
    echo ""
    exit
fi

date=$(date '+%Y-%m-%d-%H')
kdbback_final="${kdbback_dest}/kdbback_final"
LD_LIBRARY_PATH="${kdb_home}/lib"

echo "check begin : $(date '+%Y-%m-%d %H:%M:%S')"
if [[ $# -eq 1 ]] && [[ $1 = "latest" ]];then
    echo "we just check the latest logical dump file for every database"
    check_latest=$1
else
    echo "check all logical dump file for every database"
    check_latest="all"
fi

####################### kingbase backup dest test ##################

echo "kdbback_dest: "$kdbback_dest
if [ ! -d ${kdbback_dest} ];then
    echo "backup dest is not exist, please check your backup8.conf!"
    exit -1
fi
echo ""


####################### kingbase backup check  #######################

cd ${kdbback_dest}
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
echo "1.start check all database's logical backup file"
for db in `echo $kdb_list | sed 's/,/ /g'`; do
    echo "---------------------------------------------------------------------"
    echo "begin check database's logical backup, database name: " $db 
	if [ ! -d ${db} ]; then
	    echo ">>>database dose not have logical backup, please check it! "$kdbback_dest/$db
	    continue
    fi
    cd ${db}
    ##### kingbase server check as follows
    ${kdb_home}/bin/ksql -h ${kdb_host} -p ${kdb_port} -U ${kdb_user} -W ${kdb_pass}  -c "select now();" $db> /dev/null 2>&1
    if [ $? -ne 0 ] ;then
        echo "database: $db is not alive, please check it!" 
        ###TODO: database is not alive, do't care
    else
        echo "kingbase server is runing" 
    fi
    ##### end

    ##### kingbase backup files process as follows
    backup_files=$(ls $db*.tar.gz)
    if [ $check_latest = "latest" ]; then backup_files=$(ls -lrth $db*.tar.gz|tail -n 1|awk '{print $9}');fi
    for backup_file in $backup_files;
    do
        echo "----------------------"
        echo "begin check backup file: "$backup_file
        tar xzOf $backup_file|$kdb_home/bin/sys_restore -l
        echo "end check backup file: "$backup_file
        echo "----------------------"
        echo ""
    done

    echo "end check database $db's logical backup" 
    echo "---------------------------------------------------------------------"
    echo ""

    cd ../
done

echo "2.backup file list: "
for db in `echo $kdb_list | sed 's/,/ /g'`; do
    echo "database: $db, path: $kdbback_dest/$db"
    ls -rlth ${db}/${db}*.tar.gz
    echo ""
done

echo "$(date '+%Y-%m-%d %H:%M:%S') : end check all database's logical backup file"
echo ""
exit 0
