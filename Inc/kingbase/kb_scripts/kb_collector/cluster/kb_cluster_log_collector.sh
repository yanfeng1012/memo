#!/bin/bash

####################################################################################################################                                                                                                                                                 
###                                                                                                                                                                                                                                                                  
### Descipt: this tool help us to collect local kingbase or cluster log, make troubleshooting more easiy  
###          must running on the primary node
### Author : HM
### Create : 2020-04-30
###
### Usage  :
###        1.input the cluster node info: cluster_log_collector.conf
###        cluster_home="/home/kingbase/cluster/test"
###        cluster_data="/home/kingbase/cluster/test/db/data"
###        primary_host="192.168.5.132"
###        slave_host="192.168.5.133 192.168.5.134"
###        sys_user=root
###        password=root
###        ssh_port=22
###
###        2./kb_cluster_log_collector.sh
###
####################################################################################################################

#TODO: the password is not need any more, make sure


echo "This tool help use to collect local kingbase or cluster log, make troubleshooting more easiy"
#echo "must running on the primary node"
echo ""

if [[ $# -eq 1 ]] && [[ $1 = "-h" ]] || [[ $1 = "--help" ]];then
    echo "Usage:"
    echo "1.input the cluster node info: cluster_log_collector.conf"
    echo "
    cluster_home="/home/kingbase/cluster/clusterName"
    cluster_data="/home/kingbase/cluster/clusterName/db/data"
    primary_host="192.168.5.132"
    slave_host="192.168.5.133"
    sys_user=root
    password=root
    ssh_port=22"
    echo ""
    echo "2./kb_cluster_log_collector.sh"
    echo ""
    exit
fi

date_str=$(date "+%Y-%m-%d_%H-%M-%S")
current_path=$PWD

# get configuration

conf_file=$(dirname $(readlink -f "$0"))"/cluster_log_collector.conf"
echo "conf file is: $conf_file"
#source $conf_file

cluster_home=`cat $conf_file |grep cluster_home|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
cluster_data=`cat $conf_file |grep cluster_data|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
primary_host=`cat $conf_file |grep primary_host|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
slave_host=`cat $conf_file |grep slave_host|awk -F'=' '{print $2}'`
sys_user=`cat $conf_file |grep sys_user|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
ssh_port=`cat $conf_file |grep ssh_port|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`
db_version=`cat $conf_file |grep db_version|awk -F'=' '{print $2}'|sed s/[[:space:]]//g`

if [ ! $db_version ]; then
    db_version="R3"
fi
echo "db_version is: $db_version"


echo "check your conf:"
if [ $db_version = "R3" ]; then
    if [[ ! -d $cluster_home ]] || [[ ! -d $cluster_home/db ]]; then
        echo "cluster_home: $cluster_home is not correct, please check your cluster_log_collector.conf and try again !"
        exit
    fi
else
    if [[ ! -d $cluster_home ]] || [[ ! -d $cluster_home/kingbase ]]; then
        echo "cluster_home: $cluster_home is not correct, please check your cluster_log_collector.conf and try again !"
        exit
    fi
fi
echo "cluster_home is correct: $cluster_home"

data_path=$cluster_data
if [[ ! -d $data_path ]] || [[ ! -f $data_path/kingbase.conf ]]; then
    echo "cluster_data is not correct, please check your cluster_log_collector.conf and try again !"
    exit
fi
echo "cluster_data is correct: $data_path"

log_path=$data_path/sys_log
if [ ! -d $log_path ]; then
    echo "the log path is not exist, please input the sys_log path:"
    read log_path
    if [ ! -d $log_path ]; then
        echo "the log path is error, please make sure and try again ! "
        exit
    fi
fi
echo "database_log_path: $log_path"
log_home=$PWD/cluster_log_$date_str
echo "log home is      : $log_home"
echo ""


#echo "collect primary node log:"
#node_role="primary"
#node_ip=$primary_host
#collect_node_log
#echo ""

function collect_node_log(){
    echo "node_role: $node_role"
    echo "node_ip  : $node_ip"
    echo ""
    
    ssh_conn=$(echo "ssh $node_ip -l $sys_user -p $ssh_port ")
    scp_conn=$(echo "scp -P $ssh_port -r $sys_user@$node_ip:")
    #echo "ssh_conn is: $ssh_conn"
    
    echo "check log dest path:"
    log_dest="$log_home/$node_role"
    if [ ! -d $log_dest ]; then
        echo "create dir: $log_dest"
        $ssh_conn mkdir -p $log_dest
    fi
    echo ""
    
    # create node file
    $ssh_conn "echo "$node_role node: $node_ip" > $log_dest/${node_role}_$node_ip"
    
    echo "collect system messages:"
    sys_msg=/var/log/messages
    if [ -f $sys_msg ]; then
        $ssh_conn cp $sys_msg $log_dest/"messages"
        echo "copyed $sys_msg  to "$log_dest/
    else
        echo "$sys_msg is not exist, ignore"
    fi
    echo ""
    
    
    #new KingbaseCluster changed the log dir from /tmp to cluster/log/
    #echo "collect cluster log in /tmp/:"
    #$ssh_conn "cd /tmp/ && tar czvf /tmp/log_from_tmp.tar.gz cluster_restart.log clusterstop failover.log kbstart kbstop pool_nodes recovery.log"
    #$ssh_conn "mv /tmp/log_from_tmp.tar.gz $log_dest/"
    #echo ""
    
    
    if [ $db_version = "R3" ]; then
        echo "collect cluster.log in cluster_home/log/:"
        $ssh_conn "cd $cluster_home/log && tar czvf /$cluster_home/log/cluster_home_log.tar.gz cluster.log cluster_restart.log clusterstop failover.log kbstart kbstop pool_nodes recovery.log"
        $ssh_conn "mv $cluster_home/log/cluster_home_log.tar.gz $log_dest/"
    else
        #TODO: The R6 cluster have some event in table: repmgr.events, repmgr.monitoring_history, repmgr.nodes, repmgr.replication_status. now get it in the polling scripts
        echo "collect cluster log in cluster_home/kingbase/:"
        $ssh_conn "cd $cluster_home/kingbase && tar czvf /$cluster_home/kingbase/cluster_home_log.tar.gz hamgr.log kbha.log logfile"
        $ssh_conn "mv $cluster_home/kingbase/cluster_home_log.tar.gz $log_dest/"
    fi
    echo ""


    echo "collect last five kingbase log from $log_path:"
    csv_log_count=$($ssh_conn "ls $log_path|grep csv|wc -l")
    if [ $csv_log_count -gt 0 ]; then
        echo "log type: csv"
        logfiles=$($ssh_conn "ls -rlth $log_path|tail -n 10|grep csv"|awk '{print $9}')
    else
        echo "log type: log"
        logfiles=$($ssh_conn "ls -rlth $log_path|tail -n 5|grep log"|awk '{print $9}')
    fi
    
    #echo "debug: logfiles: $logfiles"
    
    tar_str="cd $log_path && tar czvf $log_path/database_log.tar.gz"
    for file in $logfiles; 
    do
        tar_str=$(echo "$tar_str $file") 
    done
    $ssh_conn $(echo $tar_str)
    $ssh_conn "mv $log_path/database_log.tar.gz $log_dest/"
    echo ""
    
    echo "current log file list: $log_dest"
    $ssh_conn "ls -rlth $log_dest|grep -v collector"
    echo ""
    
    echo "cp the log files from $node_role to local:"
    $scp_conn$log_dest $log_home 
    echo "done"
}


#main:

echo "collect primary node log:"
echo "------------------------------------------------------------------"
node_role="primary"
node_ip=$primary_host
collect_node_log
echo "------------------------------------------------------------------"

echo ""
echo "collect slave node log:"
echo "------------------------------------------------------------------"
index=1
for one_host in $slave_host;
do    
    node_role="slave$index"
    node_ip=$one_host
    echo "collect slave$index:"
    collect_node_log

    index=$(echo "$index+1"|bc)
    #echo "index: $index"
    echo "------------------------------------------------------------------"
done

echo ""
echo "collect cluster log sucess, tar those log file:"
cd $log_home
tar czvf cluster_log_$date_str.tar.gz *
cd $current_path
echo ""

echo "log file list:"
ls -rlth $log_home
echo ""
