## [Atlas 解决redis 内存不够的问题](https://github.com/Qihoo360/Atlas/blob/master/README_ZH.md)

- 下载

	从[https://github.com/Qihoo360/Atlas/releases](https://github.com/Qihoo360/Atlas/releases) 页面下载最新版RPM包
	
- 安装

		sudo rpm –i Atlas-XX.el6.x86_64.rpm

- 注意事项：

		(1).Atlas只能安装运行在64位的系统上。
		
		(2).Centos 5.X安装 Atlas-XX.el5.x86_64.rpm，Centos 6.X安装Atlas-XX.el6.x86_64.rpm。
		
		(3).如果执行sudo rpm –i Atlas-XX.el6.x86_64.rpm，提示类似：“file /usr/local/mysql-proxy/bin/encrypt from install of Atlas-2.0.1-1.x86_64 conflicts with file from package Atlas-1.0.3-1.x86_64”错误，则表示该系统之前已经安装过Atlas-1.0.3-1.x86_64，需要执行：sudo rpm –e Atlas-1.0.3-1.x86_64，将之前安装的Atlas删除掉，再执行sudo rpm –i Atlas-XX.el6.x86_64.rpm安装新版本的Atlas。
		
		(4).后端mysql版本应大于5.1，建议使用Mysql 5.6
		
- 配置

>Atlas运行需要依赖一个配置文件（test.cnf）。在运行Atlas之前，需要对该文件进行配置。<br/>
>Atlas的安装目录是/usr/local/mysql-proxy，进入安装目录下的conf目录，可以看到已经有一个名为test.cnf的默认配置文件，我们只需要修改里面的某些配置项，不需要从头写一个配置文件。


- eg:

		[mysql-proxy]
		
		管理接口的用户名
		admin-username = user
		
		管理接口的密码
		admin-password = pwd
		
		Atlas后端连接的MySQL主库的IP和端口，可设置多项，用逗号分隔
		proxy-backend-addresses = 192.168.1.1:3306
		
		从库
		proxy-read-only-backend-addresses = 192.168.1.2:3306@1
		
		用户名和密码配置项，需要和主从复制配置的用户名和密码配置一样
		r1:+jKsgB3YAG8=, user2:GS+tr4TPgqc=
		
		后台运行
		daemon = true keepalive = false
		
		工作线程数，对Atlas的性能有很大影响，可根据情况适当设置
		event-threads = 4
		
		日志级别，分为message、warning、critical、error、debug五个级别
		log-level = error
		
		日志存放的路径
		log-path = ./log
		
		SQL日志的开关，可设置为OFF、ON、REALTIME，OFF代表不记录SQL日志，ON代表记录SQL日志，REALTIME代表记录SQL日>志且实时写入磁盘，默认为OFF
		sql-log = OFF
		
		慢日志输出设置。当设置了该参数时，则日志只输出执行时间超过sql-log-slow（单位：ms)的日志>记录。不设置该参数则输出全部日志。
		sql-log-slow = 1000
		
		实例名称，用于同一台机器上多个Atlas实例间的区分
		instance = web
		
		Atlas监听的工作接口IP和端口
		proxy-address = 0.0.0.0:13470
		
		Atlas监听的管理接口IP和端口
		admin-address = 0.0.0.0:23470
		
		分表设置，此例中person为库名，mt为表名，id为分表字段，3为子表数量，可设置多项，以逗号分>隔，若不分表则不需要设置该项
		tables = person.mt.id.3
		
		默认字符集，设置该项后客户端不再需要执行SET NAMES语句
		charset = utf8
		
		允许连接Atlas的客户端的IP，可以是精确IP，也可以是IP段，以逗号分隔，若不设置该项则允许所>有IP连接，否则只允许列表中的IP连接
		client-ips = 127.0.0.1, 192.168.1
		
		Atlas前面挂接的LVS的物理网卡的IP(注意不是虚IP)，若有LVS且设置了client-ips则此项必须设置>，否则可以不设置
		lvs-ips = 192.168.1.1
		
- 运行Atlas

	进入/usr/local/mysql-proxy/bin目录，执行下面的命令启动、重启或停止Atlas。
		
		(1).sudo ./mysql-proxyd test start，启动Atlas。
		
		(2).sudo ./mysql-proxyd test restart，重启Atlas。
		
		(3).sudo ./mysql-proxyd test stop，停止Atlas。
		
	注意：
		
		(1).运行文件是：mysql-proxyd(不是mysql-proxy)。
		
		(2).test是conf目录下配置文件的名字，也是配置文件里instance项的名字，三者需要统一。
		
		(3).可以使用ps -ef | grep mysql-proxy查看Atlas是否已经启动或停止。
		
	- 执行命令：

			mysql -h127.0.0.1 -P1234 -u用户名 -p密码，如果能连上则证明Atlas初步测试正常，可以再尝试发几条SQL语句看看执行结果是否正确。
		
	- 进入Atlas的管理界面的命令：

			mysql -h127.0.0.1 -P2345 -uuser -ppwd，进入后执行:select * from help;查看管理DB的各类命令。