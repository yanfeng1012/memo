## linux 安装 mysql 8.0.16

### 0.系统与安装包
	
- 查看Linux版本

	- `cat /etc/issue`

- mysql 安装包下载

	- 地址 [https://dev.mysql.com/downloads/file/?id=486010](https://dev.mysql.com/downloads/file/?id=486010)

### 1.安装前检查

- 查看防火墙状态

	`service iptables status`
	
	如果开启关闭防火墙 `service iptables stop`
	
- 查看seLinux 状态

	`getenforce`
	
	- 关闭selinux 

		- 临时 `setenforce 0 `
		- 永久 `修改/etc/selinux/config 文件 将SELINUX=enforcing改为SELINUX=disabled `

- 是否安装MySQL

	`rpm -qa | grep mysql`
	
	- 删除MySQL `rpm -ev mysql_*`  删除MySQL所在位置文件
	- 停止原MySQL 删除/usr/local 下的MySQL目录

- 是否安装mariadb

	`rpm -qa | grep mariadb` 
	
	如果有 彻底删除mariadb
	
- 是否安装了 libaio 

	`rpm -qa | grep libaio`
	
	`yum -y install libaio`
	
### 2.安装MySQL

1. sftp 上传文件包至家目录（eg:`/root`） (eg：`mysql-8.0.16-linux-glibc2.12-x86_64.tar`)

2. 解压文件包

		tar -xvf mysql-8.0.16-linux-glibc2.12-x86_64.tar
		
3. 移动并重命名

		mv mysql-8.0.16-linux-glibc2.12-x86_64 /usr/local/mysql
		
4. 创建mysql用户组及用户

		groupadd mysql
		useradd -r -g mysql mysql
	
5. 添加/编辑MySQL配置

	`vim /etc/my.cnf`
		
		[client]
		port        = 3306
		# 设置mysql客户端默认字符集 
		default-character-set=utf8  
		socket      = /tmp/mysql.sock
		
		[mysqld]
		user        = mysql # 用户
		port        = 3306
		socket      = /tmp/mysql.sock # sock 目录 
		datadir = /usr/local/mysql/data # 数据目录
		#pid-file = /usr/local/mysql/data/xxx.pid #无需指定在 datadir 下
		tmpdir = /tmp
		# 默认使用“mysql_native_password”插件认证
		default_authentication_plugin=mysql_native_password
		skip-external-locking
		key_buffer_size = 256M
		max_allowed_packet = 1M
		table_open_cache = 1024
		sort_buffer_size = 4M
		net_buffer_length = 8K
		read_buffer_size = 4M
		read_rnd_buffer_size = 512K
		myisam_sort_buffer_size = 64M
		thread_cache_size = 128
		query_cache_size = 128M
		tmp_table_size = 128M
		performance_schema_max_table_instances = 500
		
		explicit_defaults_for_timestamp = true
		#skip-networking
		max_connections = 500
		max_connect_errors = 100
		open_files_limit = 65535
		
		binlog_format = row
		#log-bin = mysql-bin
		expire_logs_days = 7
		max_binlog_size = 1G
		binlog_cache_size = 4m # mysql8 不支持
		max_binlog_cache_size = 512m
		binlog_row_image = full
		
		default_storage_engine = InnoDB
		innodb_file_per_table = 1
		innodb_data_home_dir = /usr/local/mysql/var
		innodb_data_file_path = ibdata1:10M:autoextend
		innodb_log_group_home_dir = /usr/local/mysql/var
		innodb_buffer_pool_size = 1024M
		innodb_log_file_size = 256M
		innodb_log_buffer_size = 8M
		innodb_flush_log_at_trx_commit = 1
		innodb_lock_wait_timeout = 50
		
		[mysqldump]
		quick
		max_allowed_packet = 16M
		
		[mysql]
		no-auto-rehash
		
		[myisamchk]
		key_buffer_size = 256M
		sort_buffer_size = 4M
		read_buffer = 2M
		write_buffer = 2M
		
		[mysqlhotcopy]
		interactive-t:imeout

6. 设置MySQL目录的访问权限

		[root@localhost mysql]# chown -R mysql:mysql ./
		
7. 初始化数据库

		[root@localhost mysql]# ./bin/mysqld --initialize


	- 1 如果出现 `error while loading shared libraries:libnuma.so.1 ...` 
	
			yum install numactl
	
	ps: 初始化成功后 在最后会有 数据库root初始密码 
    `[NOTE] A temporary password is generated for root@localhost: #qweRDFG(`
    
8. 启动MySQL

		[root@localhost mysql]# cd support-files
		[root@localhost support-files]# ./mysql.server start
		
9. 设置开机启动MySQL

		cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
		cp /usr/local/mysql/support-files/mysql.server /etc/rc.d/init.d/mysql
		chmod 700 /etc/init.d/mysql
		chkconfig --add mysqld
		chkconfig --level 2345 mysqld on
		chown mysql:mysql -R /usr/local/mysql/
	
10. 设置mysql 全局变量

		cp /usr/local/mysql/bin/mysql /usr/bin/

11. 修改root初始密码

		ALTER USER "root"@"localhost" IDENTIFIED  BY "你的新密码";


	

		 





