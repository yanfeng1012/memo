## Kingbase(人大金仓数据库)

### kingbase 安装及常见问题

- [DQL、DML、DDL、DCL](https://blog.csdn.net/qq_39626154/article/details/83584697)

- 设置环境变量

		export KINGBASE_DATA=/opt/kingbase/ES/V8/data
		export LD_LIBRARY_PATH=$PATH:/opt/kingbase/ES/V8/Server/lib
		export PATH=$PATH:/opt/kingbase/ES/V8/Server/bin

- 初始化数据库(安装失败时，重新安装时使用)

		initdb -D /opt/kingbaseES/V8/data --case-insensitive -USYSTEM -W123456
		
- `ind_in_set` 替换为 `find-string = ANY (string_to_array(some_column,','))` 

- `date-format` 替换为 `to_char`

- 查看表空间文件路径 
	- `select sys_relation_filepath('tablename')`;
	- `\db`
	- `数据库对象管理工具 表空间查看`
	- `ls $KINGBASE_DATA/sys_tablspc`

	
- 逻辑备份
	- 备份 `sys_dump --help` 
		- `copy` 

				copy table_name to file_name
			
		- `sys_dump`  
		
				基础用例: 
				sys_dump dbname > outfile
				eg:
				sys_dump -h 192.168.1.8 -p 54321 -U SYSTEM -W MANAGER -f /home/KingbaseES/V8R3/bin/dumpfile.sql TEST
				sys_dump -h 192.168.1.8 -p 54321 -U SYSTEM -W MANAGER TEST > /home/KingbaseES/V8R3/bin/dumpfile.sql 
		
		- `sys_dumpall`

				使用sys_dumpall对全部数据库进行备份:
				
				sys_dumpall -h 192.168.1.8 -p 54321 -U SYSTEM -W MANAGER -f /home/KingbaseES/V8R3/bin/dumpfile.sql TEST
				
				sys_dumpall -h 192.168.1.8 -p 54321 -U SYSTEM -W MANAGER TEST > /home/KingbaseES/V8R3/bin/dumpfile.sql 
		
	- 还原 
		- 基础用例 

				sys_dump dbname < infile
		
		- 还原自定义备份格式
		 
				sys_restore -USYSTEM -d table_name /opt/Kingbase/datab_bak/db.dmp
				
		- 还原sql 

				ksql -USYSTEM table_name -f /opt/Kingbase/datab_bak/db.sql
		
		- 还原`sys_dumpall` 

				ksql -f infile kingbase (用kingbase 代替数据库名称) 
				
		- [一键备份命令脚本](/Inc/kingbase/kb_scripts/kb_backup/logical/fast_deploy_backup8.sh)
- 物理备份

	- `sys_rman`
	-  [一键备份命令脚本](/Inc/kingbase/kb_scripts/kb_backup/rman/fast_deploy_rman.sh)

- SYSTEM密码忘记(`sys_hba.conf`)

		vim $KINGBASE_DATA/sys_hba.conf
		
		修改 127.0.0.1/32 method =》 trust
		
		sys_ctl reload 
		
		ksql -h 127.0.0.1
		
		#修改密码
		\password 
		
		sys_ctl reload
		
- 用户与角色区别

	- 1、角色=组=管理大量相似功能的用户
	
			create user u1.......
			creete role oprator;

			grant u1....... to oprator;

			grant select on t1 to oprator;属于oprator组的用户，都可能读取t1;

	- 2、以下两个命令等价
	
			create user u01;
			create role u02 login;
			
	- 3、以下两组命令等价
	
			create user u2; 
			create role u2;  alter role u2 login;

	- 4、员工离职
	
			alter user u3 nologin;相当于oracle中的alter user u3 lock;
			
- 管理员分级
			
		全局管理员
		create user zcs superuser;
		\passwd zcs
		
		特定库的管理员
		create user oa1dba;
		create database oa1 owner oa1dba;
		\passwd zcs
		
		
		特定模式的管理员
		create user sch1dba;
		create schema sch1   AUTHORIZATION  sch1dba;
		\passwd sch1dba

### PHP加入金仓pdo_kdb扩展

- 编辑php.ini:

		添加:
		extension=/usr/local/php/lib/kingbase/pdo_kdb.so(文件位置)
		
- 设置环境变量（检查环境变量是否设置，如未设置将导致扩展加载失败）

		export LD_LIBRARY_PATH=/usr/local/php/lib/kingbase(文件所在文件夹)

- 测试扩展加载

		php -m | grep pdo_kdb
		
- 启动php-fpm时找不到拓展文件

		1、将人大金仓的拓展放入/etc/ld.so.conf
		/opt/kingbaseES/V8/Server/lib(数据库安装位置)
		2、执行/sbin/ldconfig 更新生效
		



	