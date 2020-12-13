#!/bin/bash
####################################################################################################################
###
###Descipt: this script is used for kingbase database page backup,before you run it,you should set the variables 
###
####################################################################################################################
####################### variable define ##########################
kdb_home="/home/v8/Kingbase/ES/V8/Server/"
kdb_data="/home/v8/data"
kdb_user="SYSTEM"
kdb_pass="123456"
kdb_port="54321"
kdb_host="127.0.0.1"
kdbback_dest="/home/v8/backup"

echo "kingbase database rman page backup begin : $(date '+%Y-%m-%d %H:%M:%S')"

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


date=$(date)
LD_LIBRARY_PATH="${kdb_home}/lib"

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH

####################### kingbase backup start  #######################
	##### kingbase server check as follows
        ${kdb_home}/bin/ksql -h ${kdb_host} -p ${kdb_port} -U ${kdb_user} -W ${kdb_pass}  -c "select now();" TEMPLATE2 > /dev/null 2>&1
        if [ $? -ne 0 ] ;then
	    echo -e "${date} \nsorry, please run the script in a kingbase server" >> ${kdbback_dest}/backup.log 
	    exit 1
        else
	    echo -e "${date} \nPAGE BACKUP START ..." >> ${kdbback_dest}/backup.log
        fi
	##### end

	##### kingbase backup  process as follows
	${kdb_home}/bin/sys_rman backup -b page -h ${kdb_host} -p ${kdb_port} -U ${kdb_user} -W ${kdb_pass} -d TEMPLATE2 -B ${kdbback_dest} -D ${kdb_data} >> ${kdbback_dest}/backup.log 2>&1  
	if [ $? -ne 0 ] ;then
	    echo "PAGE BACKUP FAILED!" >> ${kdbback_dest}/backup.log
		exit 1
	else
	echo "PAGE BACKUP SUCCEED!" >> ${kdbback_dest}/backup.log
        ${kdb_home}/bin/sys_rman show -B ${kdbback_dest} >> ${kdbback_dest}/backup.log 2>&1

	fi
	##### end
	
echo "kingbase database rman page backup end : $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

exit 0
