#!/bin/bash

####################################################################################################################
###
### Descipt: this script help us to deploy rman backup schedual into the crontab 
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
### 	   kdbarchive_dest="/data/kingbase/archive"
###        keep_num="2"
###
###        2.execute deploy:
###        ./fast_deploy_rman.sh 
###
####################################################################################################################

####################################################################################################################

echo "This tool help use to deploy rman backup (rman_full.sh, rman_page.sh) schedual into the crontab"
echo ""

echo "begin deploy, read configuration"
conf_file=$(dirname $(readlink -f "$0"))"/rman.conf"
echo "conf file is: $conf_file"
source $conf_file
echo ""

##TODO: we just mkdir the path user input, do not check the path disk useage
#archive_dest="/data/kingbase/archive"
archive_dest=$kdbarchive_dest

echo "1.check database is open archive:"
achive_open=$(cat $kdb_data/kingbase.conf |grep archive_mode|grep -v '^#'|wc -l)
if [ $achive_open -eq 0 ]; then
    echo "database do not open archive, now open it"
    if [ ! -d $archive_dest ]; then
        echo "make archive dest: "$archive_dest
        mkdir -p $archive_dest 
    fi
    chown -R kingbase:kingbase $archive_dest 
    echo "add configuration to kingbase.conf"
    cat >>$kdb_data/kingbase.conf <<EOF
#fast_deploy_rman add:
wal_level = replica
archive_mode = on
archive_command = 'test ! -f $archive_dest/%f && cp %p $archive_dest/%f'
archive_dest = '$archive_dest'
EOF
   echo "restart database, make archive open"
   su - kingbase -c "$kdb_home/bin/sys_ctl -D $kdb_data stop"
   su - kingbase -c "$kdb_home/bin/sys_ctl -D $kdb_data start"
   echo "wait database restart"
   ##TODO:sometime the restart action will cost so many time, we just wait 10 second
   sleep 10

   ##TODO:restart database by user?
   #echo "plase restart database make archive configuration work:"
   #echo "su - kingbase -c "$kdb_home/bin/sys_ctl -D $kdb_data restart""
   #echo "after restart database, run this script again"
else
    echo "database is already open archive"
fi

####################################################################################################################
echo ""
echo "2.check back_dest and archive_dest :"
echo "check $kdbback_dest :"
if [ ! -d $kdbback_dest ];then
    echo "create back dest dir: "$kdbback_dest
    mkdir -p $kdbback_dest
    chown -R kingbase:kingbase $kdbback_dest
else
    echo "back dest is exist"
fi
echo ""

echo "check $archive_dest :"
if [ ! -d $archive_dest ];then
    echo "create archive dest dir: "$archive_dest
    mkdir -p $archive_dest
    chown -R kingbase:kingbase $archive_dest
else
    echo "archive dest is exist"
fi
echo ""

####################################################################################################################
echo "3.check rman_full.sh script:"
#rman_full.sh will check the database is alive, so we just need check rman_full.sh 
./rman_full.sh >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "backup test failed, please check the rman.conf and make sure database is alive"
    echo ""
    exit
else
    echo "sucess to execute rman_full.sh"
fi

./rman_page.sh >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "backup test failed, please check the rman.conf"
    echo ""
    exit
else
    echo "sucess to execute rman_page.sh"
fi
echo ""


####################################################################################################################
echo "4.add backup job:"
log_file=$PWD"/rman_backup.log"
cron_conf=$(crontab -l)
cron_exist=$(crontab -l|grep rman_full.sh|wc -l)
if [[ -z $cron_conf ]] || [[ $cron_conf = "no crontab for root" ]]; then
    echo "there is no crontab job, add it"
    echo "0 23 * * 6 bash $PWD/rman_full.sh >>$log_file 2>&1 &" > conf && crontab conf && rm -f conf
    crontab -l > conf && echo "0 23 * * 0-5 bash $PWD/rman_page.sh >>$log_file 2>&1 &" >> conf && crontab conf && rm -f conf
elif [ $cron_exist -eq 0 ];then
    echo "there is no kingbase crontab job, add it"
    crontab -l > conf && echo "0 23 * * 6 bash $PWD/rman_full.sh >>$log_file 2>&1 &" >> conf && crontab conf && rm -f conf
    crontab -l > conf && echo "0 23 * * 0-5 bash $PWD/rman_page.sh >>$log_file 2>&1 &" >> conf && crontab conf && rm -f conf
else
    echo "do not need deploy rman_full.sh  and rman_page.sh in crontab"
fi
echo ""

####################################################################################################################
echo "5.show current crontab list:"
crontab -l

echo ""
echo "end"
