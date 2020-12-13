#!/bin/bash

####################################################################################################################                                                                                                                                                  ###                                                                                                                                                                                                                                                                   ### Descipt: this script help us update database more easily
###                                                                                                                                                                                                                                                                  
### Descipt: this script help us to deploy logical backup (backup8.sh) schedual into crontab 
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
###        2.execute deploy:
###        ./fast_deploy_backup8.sh
###
####################################################################################################################

echo "This tool help use to deploy logical backup (backup8.sh) schedual into crontab, must execute in local server"
echo ""

####################################################################################################################
echo "1.check back dest:"
kdbback_dest=`cat backup8.conf |grep kdbback_dest|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
if [ ! -d $kdbback_dest ];then
    echo "create back dest dir: "$kdbback_dest
    mkdir -p $kdbback_dest
    chown -R kingbase:kingbase $kdbback_dest
else
    echo "back dest is exist, do not create it"
fi

echo " "


####################################################################################################################
echo "2.check backup8.sh script:"
./backup8.sh >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "backup test failed, please check the backup8.conf"
    echo ""
    exit
else
    echo "sucess to execute backup8.sh"
fi

echo ""


####################################################################################################################
echo "3.add backup job:"
#current_dir=$(dirname $(readlink -f "$0"))
cron_conf=$(crontab -l)
cron_exist=$(crontab -l|grep backup8.sh|wc -l)
if [[ -z $cron_conf ]] || [[ $cron_conf = "no crontab for root" ]]; then
    #echo "0 2 * * * sh $PWD/backup8.sh >/dev/null 2>&1 &" >> conf && crontab conf && rm -f conf
    echo "0 2 * * * bash $PWD/backup8.sh >>$PWD/logical_backup.log 2>&1 &" >> conf && crontab conf && rm -f conf
elif [ $cron_exist -eq 0 ];then
    crontab -l > conf && echo "0 2 * * * bash $PWD/backup8.sh >>/$PWD/logical_backup.log 2>&1 &" >> conf && crontab conf && rm -f conf
else
    echo "do not need deploy backup8.sh in crontab"
fi
echo "complated"

echo ""


####################################################################################################################
echo "4.show current crontab list:"
crontab -l

echo ""
echo "end"
