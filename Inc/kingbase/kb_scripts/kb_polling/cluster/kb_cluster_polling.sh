#!/bin/bash

####################################################################################################################                                                                                                                                                 
###                                                                                                                                                                                                                                                                  
### Descipt: this tool help us to make a database cluster poling 
### Author : HM
### Create : 2020-04-28
###
### Usage  :
###        ./kb_polling.sh cluster_vip cluster_port db_user cluster_password db_name
###
####################################################################################################################


echo "This tool help use to make a database polling, must execute in local server"
echo ""

echo "kingbase database polling begin : $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

if [ $# -eq 6 ]; then
    cluster_vip=$1
    cluster_port=$2
    db_user=$3
    db_pwrd=$4
    db_name=$5
    db_version=$6
else
    echo "the parameter is error, please check again !"
    echo "Usage:"
    echo "kb_polling_cluster.sh cluster_host cluster_port db_user db_password db_name db_version"
    echo ""
    exit
fi


function R3_and_before_polling()
{
    #TODO: db_vip was't plain to check
    #TODO: cluster role was't plain to check (where is the cluster vip, where is the primary cluster node)


    main_proc_num=$(ps -ef|grep "bin/kingbase"|grep D|wc -l)
    if [ $main_proc_num -eq 0 ]; then
        echo "the database is not on live, please check it !!!"
        echo ""
        exit
    fi

    kingbase_path=$(ps -ef|grep "bin/kingbase"|grep cluster|grep D|awk '{print $8}')
    bin_path=${kingbase_path%/*}
    server_path=${bin_path%/*}
    install_path=${server_path%/*}
    db_conn=$(echo $bin_path/ksql -At -h $cluster_vip -p $cluster_port -U $db_user -W $db_pwrd -d $db_name)
    db_conn_noAt=$(echo $bin_path/ksql -h $cluster_vip -p $cluster_port -U $db_user -W $db_pwrd -d $db_name)
    #echo $db_conn

    $db_conn_noAt -c "select now();" > /dev/null 2>&1
    if [ $? -ne 0 ] ;then
        echo "the cluster is not on live, please check it !!!"
        echo "cluster connection info is: "
        echo ""$db_conn_noAt
        echo ""
        exit 1
    else
        echo "cluster status     : running"
    fi

    echo ""
    echo "local database info:"
    echo "database bin_path  :  "$bin_path

    data_dir=$(ps -ef|grep "bin/kingbase"|grep cluster|grep D|awk '{print $10}')
    if [ $data_dir = "." ]; then
        #echo "can not get data path from main process, now get it from database"
        data_dir=$($db_conn -c "show data_directory;")
    fi
    echo "database data_dir  :  "$data_dir

    db_version=$($db_conn -c "select version()")
    echo "database version   :  "$db_version

    case_sensitive=$($db_conn -c "show case_sensitive")
    echo "database sensitive : " $case_sensitive
    echo "DB PORT            : " $cluster_port

    main_proc_pid=$(ps -ef|grep kingbase|grep data|grep D|awk '{print $2}')
    echo "database main_pid  : " $main_proc_pid
    echo ""

    echo "1.show cluster info:"
    echo "----------------------------------------------------------------------------"
    $db_conn_noAt -c "show pool_nodes;"
    echo ""
    echo "----------------------------------------------------------------------------"

    echo "2.show replication stat info:"
    echo "----------------------------------------------------------------------------"
    $db_conn_noAt -c "select * from sys_stat_replication;"
    echo ""
    echo "----------------------------------------------------------------------------"

    echo "3.show wal gap info:"
    echo "----------------------------------------------------------------------------"
    $db_conn_noAt -c "select application_name, client_addr, backend_start, backend_xmin, state, sync_state, sent_location, write_location, flush_location, replay_location, 
    sys_xlog_location_diff(sent_location, replay_location) send_replay_gap, sys_xlog_location_diff(SYS_CURRENT_XLOG_LOCATION(),replay_location) current_replay_gap from sys_stat_replication;"
}


function R6_polling()
{
    #TODO: db_vip was't plain to check
    #TODO: cluster role was't plain to check (where is the cluster vip, where is the primary cluster node)


    main_proc_num=$(ps -ef|grep "bin/kingbase"|grep D|wc -l)
    if [ $main_proc_num -eq 0 ]; then
        echo "the database is not on live, please check it !!!"
        echo ""
        exit
    fi

    kingbase_path=$(ps -ef|grep "bin/kingbase"|grep cluster|grep D|awk '{print $8}')
    bin_path=${kingbase_path%/*}
    server_path=${bin_path%/*}
    install_path=${server_path%/*}
    db_conn=$(echo $bin_path/ksql -At -h $cluster_vip -p $cluster_port -U $db_user -d $db_name)
    db_conn_noAt=$(echo $bin_path/ksql -h $cluster_vip -p $cluster_port -U $db_user -d $db_name)
    #echo $db_conn

    #create .kbpass file if not exist:
    kbpass="${HOME}/.kbpass"
    if  [ ! -f $kbpass ] ; then
        echo "*:*:*:$db_user:$db_pwrd" > $kbpass
        chmod 600 $kbpass
    fi

    $db_conn_noAt -c "select now();" > /dev/null 2>&1
    if [ $? -ne 0 ] ;then
        echo "the cluster is not on live, please check it !!!"
        echo "cluster connection info is: "
        echo ""$db_conn_noAt
        echo ""
        exit 1
    else
        echo "cluster status     : running"
    fi

    echo ""
    echo "local database info:"
    echo "database bin_path  :  "$bin_path

    data_dir=$(ps -ef|grep "bin/kingbase"|grep D|awk '{print $10}')
    if [ $data_dir = "." ]; then
        #echo "can not get data path from main process, now get it from database"
        data_dir=$($db_conn -c "show data_directory;")
    fi
    echo "database data_dir  :  "$data_dir

    db_version=$($db_conn -c "select version()")
    echo "database version   :  "$db_version

    echo "DB PORT            : " $cluster_port

    main_proc_pid=$(ps -ef|grep kingbase|grep data|grep D|awk '{print $2}')
    echo "database main_pid  : " $main_proc_pid
    echo ""

    echo "1.show cluster info:"
    echo "----------------------------------------------------------------------------"
    su - kingbase -c "$bin_path/repmgr service status"
    echo ""
    echo "----------------------------------------------------------------------------"

    echo "2.show replication stat info:"
    echo "----------------------------------------------------------------------------"
    $db_conn_noAt -c "select * from sys_stat_replication;"
    echo ""
    echo "----------------------------------------------------------------------------"

    echo "3.show wal gap info:"
    echo "----------------------------------------------------------------------------"
    $db_conn_noAt -c "select application_name, client_addr, backend_start, backend_xmin, state, sync_state, sent_lsn, write_lsn, flush_lsn, replay_lsn, 
    sys_wal_lsn_diff(sent_lsn, replay_lsn) send_replay_gap, sys_wal_lsn_diff(SYS_CURRENT_wal_lsn(),replay_lsn) current_replay_gap from sys_stat_replication;"

    echo "4.show repmgr's information in db:"
    #esrep=# select relname, reltype from sys_class, sys_namespace where nspname = 'repmgr' and relnamespace = sys_namespace.oid and reltype <> 0;
    #relname       | reltype 
    #--------------------+---------
    #nodes              |   16390
    #events             |   16407
    #monitoring_history |   16415
    #show_nodes         |   16419
    #voting_term        |   16423
    #replication_status |   16448
    #(6 rows)
    echo "----------------------------------------------------------------------------"
    echo "show last 100 events in repmgr.events:"
    $db_conn_noAt -d esrep -c "select * from repmgr.events order by event_timestamp desc limit 100;";

    echo "----------------------------------------------------------------------------"
    echo "show last 10 monitor state in repmgr.monitoring_history:"
    $db_conn_noAt -d esrep -c "select * from repmgr.monitoring_history order by last_monitor_time desc limit 10;"
    
    echo "----------------------------------------------------------------------------"
    echo "show vote in repmgr.voting_term:"
    $db_conn_noAt -d esrep -c "select * from repmgr.voting_term;"
}

if [ $db_version = "R6" ]; then
    R6_polling
else
    R3_and_before_polling
fi

echo ""
echo "----------------------------------------------------------------------------"
echo "kingbase cluster polling end : $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

