#!/bin/bash

####################################################################################################################                                                                                                                                                 
###                                                                                                                                                                                                                                                                  
### Descipt: this script help us to make a base optimization for database 
### Author : HM
### Create : 2020-04-28
###
### Usage  :
###        ./optimize_database_conf.sh
###
####################################################################################################################

echo "This tool help use to make a base optimization for database" 
echo ""

set -e
#1. get database data first, if not, exit. 
# TODO: or input the data dir?
check_database_data(){
    main_proc_num=$(ps -ef|grep "bin/kingbase"|grep D|wc -l)
    if [ $main_proc_num -eq 0 ]; then
        echo "the database is not on live, please input kingbase home path:"
        read kingbase_home
        if [[ ! -d $kingbase_home ]] || [[ ! -f $kingbase_home/Server/bin/kingbase ]]; then
            echo "kingbase home path is error, please check it and try again !"
            echo ""
            exit
        fi
        server_path=$kingbase_home/Server
        bin_path=$server_path/bin
    else
        kingbase_path=$(ps -ef|grep bin/kingbase|grep D|awk '{print $8}')
        bin_path=${kingbase_path%/*}
        server_path=${bin_path%/*}
        kingbase_home=${server_path%/*}
    fi
    echo "kingbase_path    : "$kingbase_path
    echo "server_path      : "$server_path
    echo "kingbase_home    : "$kingbase_home

    data_dir=$(ps -ef|grep "bin/kingbase"|grep D|awk '{print $10}')
    if [[ $data_dir = "." ]] || [[ -z $data_dir ]]; then
        echo "can not get data path from main process, please input the data path:"
        read data_dir
        if [[ ! -d $data_dir ]] || [[ ! -f $data_dir/kingbase.conf ]]; then
            echo "data path is error"
            echo "you can use: \"find / -name kingbase.conf\" to find it"
            echo "please check and try again !"
            exit -1
        fi
    fi
    echo "database data_dir: "$data_dir

    echo "write bin_path and data_path to ${HOME}/.bash_profile"
    echo "export PATH=$PATH:$bin_path" >> ${HOME}/.bash_profile 
    echo "export KBDATA=$data_dir" >> ${HOME}/.bash_profile 
}


#2. back kingbase.conf first
# TODO: we just modify the kingbase.conf or kingbase.auto.conf?
back_kingbase_conf(){
    kingbase_conf_back="kingbase.conf_back_"$(date "+%Y-%m-%d_%H_%M_%S")
    cp $data_dir/kingbase.conf $data_dir/$kingbase_conf_back
    echo "before optimize the database, back kingbase.conf to " $kingbase_conf_back
}


#3. get system source conf, the optimize base info
get_system_config(){
    #1) get cpu cores:
    cpu_cores=$(cat /proc/cpuinfo |grep 'processor'|wc -l)
    echo "system CPU cores: " $cpu_cores

    #2) get memery KB:
    mem_kb=$(cat /proc/meminfo |grep MemTotal|awk '{print $2}')
    echo "system Mem: " $mem_kb "KB as " $(echo "$mem_kb/1024"|bc) "MB"


    #3) db_data path:
    #data_dir=$(ps -ef|grep kingbase|grep D|grep data|awk '{print $10}')
    #echo "database data dir: " $data_dir

    #4) get disk type:
    # this kind conf optimize by kingbaser
    # mount check data divice name for optimize
    #is_ssd=$(cat /sys/block/$DIVIE_NAME/queue/rotational)
    #1: SATA
    #0: SSD
}

#4. optimize database memory configuration
#shared_buffers = 128MB 
#effective_cache_size = 4GB 
#maintenance_work_mem = 64MB
#wal_buffers = -1
#work_mem = 16MB
#min_wal_size = 80MB
#max_wal_size = 1GB
optimize_db_mem(){
    kingbase_conf=$data_dir/kingbase.conf
    shared_mem=$(echo "$mem_kb/1024/4"|bc)
    echo "shared_mem: " $shared_mem "MB"

    cat >>$kingbase_conf <<EOF
#add by optimize tool:
max_connections = 2000
shared_buffers = ${shared_mem}MB
effective_cache_size = $(echo "$mem_kb/1024 - $shared_mem"|bc)MB
min_wal_size = 2GB
max_wal_size = 8GB
EOF
    if [ $mem_kb -lt $(echo "32*1024*1024"|bc) ]; then
        echo "maintenance_work_mem = $(echo "$shared_mem/4"|bc)MB">>$kingbase_conf
    else
        echo "maintenance_work_mem = 2GB">>$kingbase_conf
    fi

    #TODO: work_mem do not optimize rigth now
    #TODO: temp_buffers do not optimize rigth now
}

##5. optimize database checkpoint
optimize_checkpoint(){
    kingbase_conf=$data_dir/kingbase.conf
    cat >>$kingbase_conf <<EOF
checkpoint_completion_target = 0.9
checkpoint_timeout = 30min
EOF

}

#6. optimize database parallel
optimize_parallel(){
    kingbase_conf=$data_dir/kingbase.conf
    echo "max_worker_processes = $cpu_cores">>$kingbase_conf
    if [ $cpu_cores -ge 8 ]; then
        echo "max_parallel_workers_per_gather = 4">>$kingbase_conf
    elif [ $cpu_cores -ge 2 ]; then
        echo "max_parallel_workers_per_gather = $(echo "$cpu_cores/2"|bc)">>$kingbase_conf
    else
        #do not open parallel 
        echo "do not open parallel"
    fi
}

#7. restart database, make the conf work
restart_db(){
    kingbase_path=$(ps -ef|grep kingbase|grep data|grep D|awk '{print $8}')
    bin_path=${kingbase_path%/*}
    su - kingbase -c "$bin_path/sys_ctl -D $data_dir restart -l restart.log"
}

#main:
echo "begin optimize database"
#1. get database data first, if not, exit. 
echo "1.get database data, check database is alive"
check_database_data
echo ""

#2. back kingbase.conf first
echo "2.back kingbase.conf file"
back_kingbase_conf
echo ""

#3.get system conf
echo "3.get system resource"
get_system_config
echo ""

#4. optimize database memory configuration
echo "4.optimize database memory"
optimize_db_mem
echo ""

#5. optimize database checkpoint
echo "5.optimize database checkpoint"
optimize_checkpoint
echo ""

#6. optimize database parallel
echo "6.optimize database parallel"
optimize_parallel
echo ""

echo "end optimize database"
echo ""
echo "7.restart database to make those configuration work"
echo "please chose if restart database, 0: no, 1: yes:"
#7. restart database, make the conf work
read restart_option
if [ $restart_option -eq 1 ]; then
    restart_db
else
    echo "please restart database by hand to make those configuration work"
    echo "usage:"
    echo "su - kingbase -c "$bin_path/sys_ctl -D $data_dir restart -l restart.log""
fi

echo ""
echo "end"
