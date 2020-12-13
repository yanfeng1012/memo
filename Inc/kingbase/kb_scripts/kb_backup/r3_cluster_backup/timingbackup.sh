#!/bin/bash

curPath=$(readlink -f "$(dirname "$0")")
#load configuration file
if [ -f $curPath/backup.conf ]
then
    source $curPath/backup.conf
elif [ -f $curPath/../share/backup.conf ]
then
    source $curPath/../share/backup.conf
else
    echo "no backup.conf file,please configuration it at $curPath or $curPath/../share"
    exit 1
fi

#determine whether the user call setcron function is root, if it is root excute setcron_do
function setcron()
{
    if [ "$UID"x = "0"x ]
    then
        setcron_do
    else
        echo "excute setcron user is not root, exit"
        exit 1
    fi
}

#determine whether the user call stopcron function is root, if it is root excute stopcron_do
function stopcron()
{
    if [ "$UID"x = "0"x ]
    then
        stopcron_do
    else
        echo "excute stopcron user is not root, exit"
        exit 1
    fi
}

#Acorrding to the configuration, write the cron task
function setcron_do()
{
    if [ "$cron_day"x = ""x ]
    then
        cron_day=1
    fi
    if [ "$cron_hour"x = ""x ]
    then
        cron_hour=2
    fi
    if [ $cron_day -lt 1 -o $cron_hour -lt 0 ]
    then
        echo "cron_day or cron_hour set error, exit"
        exit 1
    fi
    local crontablist="0 $cron_hour */$cron_day * * $cron_user $curPath/timingbackup.sh backup >/dev/null 2>&1 &"
    local cronexist=`cat /etc/cron.d/KES-BACKUP 2>/dev/null | grep -wFn "${crontablist}" |wc -l`
    if [ $cronexist -eq 1 ]
    then
        local realist=`cat /etc/cron.d/KES-BACKUP 2>/dev/null | grep -wFn "${crontablist}"`
        local linenum=`echo "$realist" |awk -F':' '{print $1}'`

		sed "${linenum}s/#//g" /etc/cron.d/KES-BACKUP > /etc/cron.d/crontab.bak
		cat /etc/cron.d/crontab.bak > /etc/cron.d/KES-BACKUP	
        
        rm -fr --interactive=never /etc/cron.d/crontab.bak
    elif [ $cronexist -eq 0 ]
    then
        echo "$crontablist" >> /etc/cron.d/KES-BACKUP

    else
        echo "crond is bad ,please check!"
        exit 1
    fi
    echo "set cron done."
}

#unload the cron task
function stopcron_do()
{
    local crontablist="0 $cron_hour */$cron_day * * $cron_user $curPath/timingbackup.sh backup >/dev/null 2>&1 &"
    local cronexist=`cat /etc/cron.d/KES-BACKUP 2>/dev/null| grep -wFn "${crontablist}" |wc -l`
    if [ $cronexist -eq 1 ]
    then
        local realist=`cat /etc/cron.d/KES-BACKUP 2>/dev/null | grep -wFn "${crontablist}"`
        local linenum=`echo "$realist" |awk -F':' '{print $1}'`
        
		sed "${linenum}s/^/#/"  /etc/cron.d/KES-BACKUP > /etc/cron.d/crontab.bak
		cat /etc/cron.d/crontab.bak > /etc/cron.d/KES-BACKUP
        rm -f /etc/cron.d/crontab.bak
    fi
    echo "delete cron done."
}

#Acorrding the configuration, del the backup files
function del_backup_file()
{
    date=$(date '+%Y%m%d%H%M%S')
    for del_ing in `find ${delete_path} -maxdepth 1 |grep "\.ing"`
    do
        echo "`date` rm -fr --interactive=never ${del_ing%.*}* " >> $backup_path/backup.log
        rm -fr --interactive=never ${del_ing%.*}*
    done

    num_sum=`find ${delete_path} -maxdepth 1 -name "*backup*" -type f|wc -l`
    num_del=$[${num_sum}-${num_keep}]

    if [ $num_del -gt 0 ]
    then
        for item in `find ${delete_path} -maxdepth 1 -name "*backup*" -type f |xargs ls -t |tail -${num_del}`
        do
            if [ ! -f "${item}" ];then
                echo " No such file or directory" >> $backup_path/backup.log
            else
                del_flag=`find $item -mtime +${keep_day} -type f|wc -l`
                if [ $del_flag -eq 1 ]
                then
                    echo "`date` rm -fr --interactive=never $item" >> $backup_path/backup.log
                    rm -fr --interactive=never $item 
                    if [ $? -eq 0 ]
                    then
                        if [ ! -f "${item}" ]
                        then
                            echo "delete file success" >> $backup_path/backup.log
                        else
                            echo "delete file failed" >> $backup_path/backup.log
                        fi
                    else
                        echo "delete file failed" >> $backup_path/backup.log
                    fi
                fi
            fi
        done
    fi
    echo "`date` remove backup file by retention strategy done."

    # Clean up archives
    if [ -n "$start_wal_file" ]
    then
        cd $archive_path
        backup_history_file=`ls $start_wal_file*.backup`
        ${kb_path}/sys_archivecleanup $archive_path $backup_history_file -d >> $backup_path/backup.log 2>&1
        # Clean up backup history files, try not to remove any file that may be used by others.
        # Consider operation across a day, 3 days should be enough.
        find $archive_path -mtime +3 -name "*.backup" -exec rm -rf {} \;
        echo "`date` remove archives done."
    fi
}

function physical_backup()
{
    date=$(date '+%Y%m%d%H%M%S')
    num_keep=$physical_keep_backup_file_num

    if [ $pass_encryption -eq 1 ]
    then
        db_passwd=`echo $db_pass |base64 -d`
    else
        db_passwd=$db_pass
    fi

    [ ! -d $backup_path/physical ] && mkdir -p  $backup_path/physical
    delete_path=$backup_path/physical
    touch $backup_path/physical/${date}_data.ing
    echo "`date` ${kb_path}/sys_basebackup -h${db_host} -p ${db_port} -U ${db_user} -W ****** -F p -X stream -D  $backup_path/physical/${date}_data" >> $backup_path/backup.log
    ${kb_path}/sys_basebackup -h ${db_host} -p ${db_port} -U ${db_user} -W ${db_passwd} -F p -X stream -D  $backup_path/physical/${date}_data >> $backup_path/backup.log 2>&1
    if [ $? -eq 0 ]
    then
        cd $backup_path/physical/
        tar zcvf physical_backup_${date}.tar.gz ${date}_data 1>/dev/null 2>&1
	# extract start wal file, used to clean archive
	if [ -n "$archive_path" ]
	then
		if [ -d "$archive_path" ]
		then
			start_wal_file=`head -n 1 ${date}_data/backup_label | awk {'print $6'} | sed 's/)//'`
		else
			echo "`date` warning: archive_path $archive_path doesn't exist."
		fi
	fi
        if [ $? -eq 0 ]
        then
            rm -fr --interactive=never $backup_path/physical/${date}_data
            rm -f --interactive=never $backup_path/physical/${date}_data.ing
            echo "`date` physical backup and tar physical_backup_${date}.tar.gz done."
        else
            echo "`date` tar backup file failed" >> $backup_path/backup.log
        fi
    else
        echo "`date` sys_basebackup excute failed" >> $backup_path/backup.log
    fi
    del_backup_file
}

function logical_backup()
{
    date=$(date '+%Y%m%d%H%M%S')
    num_keep=$logical_keep_backup_file_num

    if [ $pass_encryption -eq 1 ]
    then
        db_passwd=`echo $db_pass |base64 -d`
    else
        db_passwd=$db_pass
    fi

    [ ! -d $backup_path/logical ] && mkdir -p  $backup_path/logical
    delete_path=$backup_path/logical
    OLD_IFS="$IFS"
    IFS=","
    db_arr=($db_list)
    IFS="$OLD_IFS"
    success_num=0
    for db in ${db_arr[@]}
    do
        touch $backup_path/logical/${db}_${date}.dmp.ing
        echo "`date` ${kb_path}/sys_dump -h ${db_host} -p ${db_port} -U ${db_user} -W ****** -Fc -f $backup_path/logical/${db}_${date}.dmp ${db}" >> $backup_path/backup.log
        ${kb_path}/sys_dump -h ${db_host} -p ${db_port} -U ${db_user} -W ${db_passwd} -Fc -f $backup_path/logical/${db}_${date}.dmp ${db} >> $backup_path/backup.log 2>&1
        if [ $? -ne 0 ]
        then
            echo "`date` sys_dump excute failed" >> $backup_path/backup.log
        else
            success_num=1
        fi
        
    done
    cd $backup_path/logical/
    if [ $success_num -gt 0 ]
    then
        tar zcvf logical_backup_${date}.tar.gz *_${date}.dmp 1>/dev/null 2>&1
        if [ $? -eq 0 ]
        then
            rm -f --interactive=never $backup_path/logical/*.dmp.ing
            echo "`date` logical backup and tar logical_backup_${date}.tar.gz done."
        else
            echo "`date` tar backup file failed" >> $backup_path/backup.log
        fi
    fi
    echo "`date` rm -fr --interactive=never *_${date}.dmp" >> $backup_path/backup.log
    rm -fr --interactive=never *_${date}.dmp

    del_backup_file
}

#list the backup files
function list()
{
    echo "list physical backup file"
    ls -l $backup_path/physical/
    echo "list logical backup file"
    ls -l $backup_path/logical/
}

main()
{
    echo "`date` backup begin..."
    #acorrding the BACKUP_FLAG determine whether the timingbackup.sh is already start
    if [ -s ${kb_path}/BACKUP_FLAG ]
    then
        IMRECOVERY_FLAG=`cat ${kb_path}/BACKUP_FLAG 2>/dev/null|head -n 1`
        if [ "$IMRECOVERY_FLAG"x = "1"x ]
        then
            pid_myself=`cat ${kb_path}/BACKUP_FLAG 2>/dev/null|sed -n '2p'`
            if [ "$pid_myself"x != ""x ]
            then
                Im_already_exist=`ls -l /proc/${pid_myself}/fd | grep -w timingbackup.sh |wc -l`
                if [ "$Im_already_exist"x = "1"x ]
                then
                    echo "I'm already backup now pid[$pid_myself], return nothing to do,will exit script will success"
                    exit 0;
                else
                    echo "Something interrupted the last backup. Go on this time" >> $backup_path/backup.log
                fi
            fi
        fi
    fi
    
    echo 1 > ${kb_path}/BACKUP_FLAG
    echo $$ >> ${kb_path}/BACKUP_FLAG
    
    if [ "$backup_mode"x = "logical"x ]
    then
        logical_backup
        echo 0 > ${kb_path}/BACKUP_FLAG
    elif [ "$backup_mode"x = "physical"x ]
    then
        physical_backup
        echo 0 > ${kb_path}/BACKUP_FLAG
    elif [ "$backup_mode"x = "both"x ]
    then
        logical_backup
        physical_backup
        echo 0 > ${kb_path}/BACKUP_FLAG
    fi
    echo "`date` backup done." 
}


case $1 in
    "setcron")
        setcron
        exit 0
        ;;
    "stopcron")
        stopcron
        exit 0
        ;;
    "backup")
        main
        exit 0
        ;;
    "list")
        list
        exit 0
        ;;
    *)
        echo "incorrect function name" 
        exit 0
esac
