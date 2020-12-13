#!/bin/bash
####################################################################################################################
###
###Descipt: this script is used for kingbase database full backup, before you run it,you should set the variables 
###
####################################################################################################################
####################### variable define ##########################

echo "kingbase database rman full backup begin : $(date '+%Y-%m-%d %H:%M:%S')"

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


echo "kdb_data: "$kdb_data

date=$(date)
LD_LIBRARY_PATH="${kdb_home}/lib"

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH

####################### kingbase backup dest test ##################
[ -d ${kdbback_dest} ] || mkdir -p ${kdbback_dest}
if [ ! -f ${kdbback_dest}/sys_rman.conf ] ;then
	${kdb_home}/bin/sys_rman init -h ${kdb_host} -p ${kdb_port} -U ${kdb_user} -W ${kdb_pass} -d TEMPLATE2 -B ${kdbback_dest} -D ${kdb_data}
	if [ $? -ne 0 ] ;then
                exit 1
        fi
	
fi

####################### kingbase backup start  #######################
	##### kingbase server check as follows
        ${kdb_home}/bin/ksql -h ${kdb_host} -p ${kdb_port} -U ${kdb_user} -W ${kdb_pass}  -c "select now();" TEMPLATE2 > /dev/null 2>&1
        if [ $? -ne 0 ] ;then
	    echo -e "${date} \nsorry, please run the script in a kingbase server" >> ${kdbback_dest}/backup.log 
	    exit 1
        else
	    echo -e "${date} \nFULL BACKUP START ..." >> ${kdbback_dest}/backup.log
        fi
	##### end

	##### kingbase backup  process as follows
	${kdb_home}/bin/sys_rman backup -b full -h ${kdb_host} -p ${kdb_port} -U ${kdb_user} -W ${kdb_pass} -d TEMPLATE2 -B ${kdbback_dest} -D ${kdb_data} >> ${kdbback_dest}/backup.log 2>&1  
	if [ $? -ne 0 ] ;then
	    echo "FULL BACKUP FAILED!" >> ${kdbback_dest}/backup.log
		exit 1
	else
	echo "FULL BACKUP SUCCEED!" >> ${kdbback_dest}/backup.log
                ${kdb_home}/bin/sys_rman show -B ${kdbback_dest} >> ${kdbback_dest}/backup.log 2>&1

	fi
	##### end
	
	##### kingbase retention process as follows
	echo "BACKUP RETENTION START ..." >> ${kdbback_dest}/backup.log
    ${kdb_home}/bin/sys_rman retention purge  --redundancy ${keep_num} -B ${kdbback_dest} >> ${kdbback_dest}/backup.log 2>&1 
	if [ $? -ne 0 ] ;then
	    echo "RETENTION FAILED!" >> ${kdbback_dest}/backup.log 
	    exit 1
	else
	    echo "RETENTION SUCCEED!" >> ${kdbback_dest}/backup.log
	   ${kdb_home}/bin/sys_rman show -B ${kdbback_dest} >> ${kdbback_dest}/backup.log 2>&1
	fi
    ##### end

echo "kingbase database rman full backup end : $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

exit 0
