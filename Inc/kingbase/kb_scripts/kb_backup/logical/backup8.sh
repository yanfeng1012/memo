
#!/bin/bash
####################################################################################################################
###
###Descipt: this script is used for kingbase database backup,before you run it,you should set the variables such as
###         kdb_home,kdbback_dest,kdb_user,kdb_pass,kdb_host,kdb_port,kdb_list,keep_time and so on.
###
####################################################################################################################
####################### variable define ##########################

#load the backup confuration
#TODO:this cmd have error
#source backup8.conf 
#source /root/kb_scripts/kb_scripts/kb_backup/logical/backup8.conf

echo "kingbase database logical backup begin : $(date '+%Y-%m-%d %H:%M:%S')"

conf_file=$(dirname $(readlink -f "$0"))"/backup8.conf"
echo "conf file is: $conf_file"
#source $conf_file


# modify the backup8.conf style: use "xxxx" replace xxxx, just benifit to source the conf file
kdb_home=`cat $conf_file |grep kdb_home|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdbback_dest=`cat $conf_file |grep kdbback_dest|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_user=`cat $conf_file |grep kdb_user|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_pass=`cat $conf_file |grep kdb_pass|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_port=`cat $conf_file |grep kdb_port|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_host=`cat $conf_file |grep kdb_host|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
kdb_list=`cat $conf_file |grep kdb_list|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
keep_time=`cat $conf_file |grep keep_time|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`

date=$(date '+%Y%m%d%H')
kdbback_final="${kdbback_dest}/kdbback_final"
LD_LIBRARY_PATH="${kdb_home}/lib"

####################### kingbase backup dest test ##################

[ -d ${kdbback_dest} ] || mkdir -p ${kdbback_dest}
[ -d ${kdbback_final} ] || mkdir -p ${kdbback_final}

####################### kingbase backup start  #######################

cd ${kdbback_dest}
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
for db in `echo $kdb_list | sed 's/,/ /g'`; do
	[ -d ${db} ] || mkdir -p ${db}
        cd ${db}
	##### kingbase server check as follows
        ${kdb_home}/bin/ksql -h ${kdb_host} -p ${kdb_port} -U ${kdb_user} -W ${kdb_pass}  -c "select now();" TEMPLATE2 > /dev/null 2>&1
        if [ $? -ne 0 ] ;then
	    echo "${date} sorry, please run the script in a kingbase server" >> backup_${db}_${date}.log 
	    mv backup_${db}_${date}.log ${kdbback_final}
	    exit 1
        else
	    echo "${date} kingbase server is ok,kingbase backup ${db} is beginning ..." >> backup_${db}_${date}.log
        fi
	##### end
        ##### kingbase backup files process as follows
	${kdb_home}/bin/sys_dump -p ${kdb_port} -U ${kdb_user} -W ${kdb_pass} -h ${kdb_host} -Fc -f ${db}_${date}.dmp ${db} >> backup_${db}_${date}.log 2>&1
        if [ $? -eq 0 ] ;then
            tar zcvf ${db}_${date}.tar.gz ${db}_${date}.dmp*
            if [ $? -eq 0 ] ;then
               rm -f ${db}_${date}.dmp*
            else
               mv ${db}_${date}.dmp* ${kdbback_final} 
            fi
            find . -mtime +${keep_time} -name ${db}'_*' | xargs -I {} rm {}
        else
	    rm -f ${db}_${date}.dmp*
        fi
        ###### end
        ###### kingbase backup log files process as follows
	tar zcvf backup_log_${db}_${date}.tar.gz backup_${db}_${date}.log
        if [ $? -eq 0 ] ;then
	       rm -f backup_${db}_${date}.log
	else
	       mv backup_${db}_${date}.log ${kdbback_final}
        fi
        find . -mtime +${keep_time} -name backup_log_${db}'_*' | xargs -I {} rm {}
        ###### end
       cd ${kdbback_dest}
done

echo "kingbase database logical backup end : $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

exit 0
