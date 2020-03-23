# My Memo :elephant: :elephant:

## [linux](http://linuxtools-rst.readthedocs.io/zh_CN/latest/index.html) ##

 - [常用命令总结](/Inc/linux/command.md)
 - [进阶](/Inc/linux/senior_command.md)
 - [firewall](/Inc/linux/firewall_command.md)
 - [DefaultConfiguration](/Inc/linux/DefaultConfiguration.md)
 - [Linux_shell_login](/Inc/linux/shell_login.md)
 - [crontab](/Inc/linux/crontab.md)&nbsp;&nbsp;&nbsp;&nbsp;[Linux定时任务](https://www.cnblogs.com/zoulongbin/p/6187238.html)
 - [Connection reset by peer原理解析](https://blog.csdn.net/yangguosb/article/details/79794571)
 - [CentOS Local yum repo](/Inc/linux/yum.md)
 - [linux 网卡配置详解](/Inc/linux/ifconfig.md)
 - [linux 安装 FFMpeg](/Inc/linux/ffmpeg.md)
 - [selinux 开启和关闭](https://blog.csdn.net/qq_39698293/article/details/79505285)
 - [关于解决RedHat6.0以上版本：Loaded plugins: product-id, refresh-packagekit, security, subscription-manager](https://blog.csdn.net/qq_37791764/article/details/78966277)
 - [yum 安装 Git](https://blog.csdn.net/t3369/article/details/79562853)
 - [Linux(CentOS)挂载数据盘](https://www.cnblogs.com/hepc/p/9241647.html)
 - [centos6.9安装vnc server](https://blog.csdn.net/andyguan01_2/article/details/86087811)
 - [traceroute](http://baijiahao.baidu.com/s?id=1597880263100015198&wfr=spider&for=pc)
 - [rsync](/Inc/linux/rsync.md)
 - [linux cache 过高](https://www.cnblogs.com/rocky-AGE-24/p/7629500.html)
 - [screen 用法](https://blog.csdn.net/qq_28832135/article/details/79831700)	

## nginx ##

- [nginx vhost conf](/Inc/nginx/vhost.md)
- [lnmp一键安装](/Inc/nginx/lnmp一键安装步骤.md)
- [nginx 413](/Inc/nginx/413.md)
- [mac brew lnmp](/Inc/nginx/brew_install.md)
- [open_basedir](/Inc/nginx/open_basedir.md)

## mysql ##

- [mysql 语法汇总](/Inc/MySql/inc/mysql.md)
- [grant 授权](/Inc/MySql/inc/grant.md)
- [创建用户（user）](/Inc/MySql/inc/user.md)
- [confguire](/Inc/MySql/inc/confguire.md)
- [sql_mode](/Inc/MySql/inc/sql_mode.md)
- [update root password](/Inc/MySql/inc/update_root_password.md)
- [mysql query](/Inc/MySql/inc/query.md)&nbsp;&nbsp;&nbsp;&nbsp;MySQL查询当天、本周、本月、上一个月的数据
- [find_in_set()](/Inc/MySql/inc/find_in_set.md) &nbsp;&nbsp;&nbsp;&nbsp; MySQL中find_in_set()函数的使用
- [mysql 主从配置](/Inc/MySql/inc/master-slave.md)
- [mysql log config](/Inc/MySql/inc/log-config.md)
- [mysql8 errors](/Inc/MySql/inc/mysql8.md)
- mysql 外键
      
        SET FOREIGN_KEY_CHECKS=0; //取消外键
        SET FOREIGN_KEY_CHECKS=1; //启用外键
        
- [mysql 关键字和保留字](https://dev.mysql.com/doc/refman/8.0/en/keywords.html)
- MySQL导出
	
        mysqldump -u 用户名 -p dbname > dbname.sql
	
- [mysql 数据去重](https://blog.csdn.net/n950814abc/article/details/82284838)
- [mysql bin_log](/Inc/MySql/inc/binlog.md)
- [linux 安装 MySQL 5.7.26](/Inc/MySql/inc/install5.7.26.md)
- [linux 安装 MySQL 8.0.16](/Inc/MySql/inc/install8.0.16.md)
- [mysql 主从 error 1032](https://blog.51cto.com/suifu/1845457)
- [into outfile](https://www.jianshu.com/p/da3d8e8de237)
- [mysql 1093](https://blog.csdn.net/qq_33674639/article/details/78875082)
- 清空表/截断表
	
	清空表：`delete from users`
	
	>清空表只是清空表中的逻辑数据，但是物理数据不清除，如主键值、索引等不被清除，还是原来的值。
	
	截断表：`truncate table users`
	
	>截断表可以用于删除表中 的所有数据。截断表命令还会回收所有索引的分配页。截断表的执行速度与不带where子句的delete（删除）命令相同，甚至比它还要快。 delete（删除）一次删除一行数据，并且将每一行被删除的数据都作为一个事务记录日志；而truncate （截断）表则回收整个数据页，只记录很少的日志项。delete（删除）和truncate（截断）都会回收被数据占用的空间，以及相关的索引。只有表的 拥有者可以截断表。
	
	>另外，truncate表之后，如果有自动主键的话，会恢复成默认值。
	
- 慢日志
	
		  # slow query log
		  slow_query_log_file = "/usr/local/mysql/query_slow.log" 
		  slow_query_log = 1 
		  long_query_time = '0.8'  

## PHP ##

- [PHP 相关](/Inc/php/php.md)
- [php errors](/Inc/php/errors.md)
- [PHP 协议详解](https://www.easyswoole.com/Cn/NoobCourse/introduction.html)
- [PHP Excel](https://github.com/PHPOffice/PhpSpreadsheet)
- [PHP declare](https://www.php.cn/php-weizijiaocheng-370428.html)
- [PHP XSS](https://www.jb51.net/article/158303.htm)
- PHP7 新特性 [菜鸟教程](https://www.runoob.com/php/php7-new-features.html)  [CSDN](https://www.runoob.com/php/php7-new-features.html)
- [stdClass](https://www.jb51.net/article/115487.htm)

## GO ##

- strconv 包
	`strconv包提供了字符串与简单数据类型之间的类型转换功能。可以将简单类型转换为字符串，也可以将字符串转换为其它简单类型。`
	- 字符串转int：`Atoi()`
	- int转字符串: `Itoa()`
	- ParseTP类函数将string转换为TP类型：`ParseBool()`、`ParseFloat()`、`ParseInt()`、`ParseUint()`。因为string转其它类型可能会失败，所以这些函数都有第二个返回值表示是否转换成功
	- FormatTP类函数将其它类型转string：`FormatBool()`、`FormatFloat()`、`FormatInt()`、`FormatUint()`
	- AppendTP类函数用于将TP转换成字符串后append到一个slice中：`AppendBool()`、`AppendFloat()`、`AppendInt()`、`AppendUint()`

- [参考](https://www.cnblogs.com/f-ck-need-u/p/9863915.html)

- [golang import 导入包语法介绍](https://blog.csdn.net/whatday/article/details/98046785)

	- 点操作

	有时候会看到如下的方式导入包：

		import( 
		    . "fmt" 
		) 
		
	这个点操作的含义就是这个包导入之后在你调用这个包的函数时，你可以省略前缀的包名，也就是前面你调用的：

		fmt.Println( "我爱公园" )
		
	可以省略的写成：

		Println( "我爱公园" )
		
	- 别名操作

	别名操作顾名思义可以把包命名成另一个用起来容易记忆的名字：
		
		import( 
		    f "fmt" 
		) 
		
	别名操作调用包函数时前缀变成了重命名的前缀，即：

     	f.Println( "我爱北京天安门" )
	
	- 下划线操作

	这个操作经常是让很多人费解的一个操作符，请看下面这个 import

		import ( 
		    “database/sql” 
		    _ “github.com/ziutek/mymysql/godrv” 
		) 
		
	下滑线 `“_”` 操作其实只是引入该包。当导入一个包时，它所有的 init() 函数就会被执行，但有些时候并非真的需要使用这些包，仅仅是希望它的 init() 函数被执行而已。这个时候就可以使用 `“_”` 操作引用该包了。即使用 `“_”` 操作引用包是无法通过包名来调用包中的导出函数，而是只是为了简单的调用其 init() 函数。
	 
## symfony ##

- [命令](/Inc/symfony/symfony.md)
- [控制器中的快捷方式](/Inc/symfony/shortcutmethods.md)
- [Security](/Inc/symfony/securities.md)
- [Service](/Inc/symfony/service.md)
- [Form](/Inc/Form/form.md)
- [How to Create a Custom Form Field Type](/Inc/Form/CustomForm.md)
- [UploadFile](/Inc/symfony/UploadFile.md)
- [Uploadifive](/Inc/symfony/uploadifive.md)
- [validation](/Inc/symfony/validation.md)
- [entity](/Inc/symfony/entity.md)
- [Creating a Command](/Inc/symfony/C_command.md)
- [Raw SQL Query](/Inc/symfony/executeUpdate.md)
- [KnpPaginatorBundle](/Inc/symfony/KnpPaginatorBundle.md)
- [phpexcel](/Inc/symfony/phpexcel.md)
- [php安装sqlsrv扩展](/Inc/symfony/sqlsrv.md)
- [TableToEntity](/Inc/symfony/TableToEntity.md)
- [Dotenv Component](/Inc/symfony/env.md)
- [datafixtures](/Inc/symfony/datafixtures.md)
- [Event Listenser](/Inc/symfony/eventlistenser.md)
- [Doctrine Query Functions](/Inc/symfony/queryfunctions.md)
- [Doctrine querybuilder limit and offset](/Inc/symfony/limit_offset.md)
- [Doctrine JOIN](/Inc/symfony/join.md)
- [twig相关](/Inc/Twig/twig.md)
- [Twig 基础](/Inc/Twig/twig.md)
- [macro](/Inc/Twig/twigs/macro.md)
- [monolog](/Inc/Monolog/monolog.md)
- [custom exception](https://symfony.com/doc/3.4/controller/error_pages.html)
- [workflow](http://www.symfonychina.com/doc/current/components/workflow.html)
	 
## redis ##

- [redis](/Inc/others/redis.md)
- [常用命令](http://doc.redisfans.com/)

## Git ##

- [Git](/Inc/git/git.md)
- [git cannot open git-upload-pack](/Inc/others/git.md)
- [git tag](https://www.jianshu.com/p/cdd80dd15593)

## composer ##

- [composer](/Inc/Composer/composer.md)
- [composer zlib_decode():data error](https://www.cnblogs.com/cxscode/p/7003756.html)

## javascript ##

- [javascript](/Inc/javascript/js.md)

## z7z8 ##

- [ES](/Inc/others/es.md)
- [circlechar](/Inc/others/circlechar.md)
- [8p](/Inc/8p/8p.md)
- [短信发送](/Inc/others/sms.md)
- [发送短信验证码验证](/Inc/others/catch_sms.md)
- [select2](/Inc/select2/select2.md)
- [80端口被占用](/Inc/others/80.md)
- [验证码插件无法正常加载](/Inc/others/captcha.md)
- [xunsearch](/Inc/xunsearch/xunsearch.md)
- [MarkDown 语法](https://www.jianshu.com/p/b03a8d7b1719) 
- [vmWarre Funsion 8](/Inc/others/vmware.md)
- [deploy symfony](/Inc/others/deploysf.md)
- [app 版本更新](/Inc/others/version.md)
- [packagist](https://www.jianshu.com/p/6d98eb756826)
- [app download](/Inc/others/app_download.md)
- [Atlas 解决redis 内存不够的问题](/Inc/others/atlas.md)
- [wechat sdk](https://github.com/overtrue/wechat)
- [guzzlehttp](/Inc/others/guzzlehttp.md)
- [HAProxy](http://www.ttlsa.com/linux/haproxy-study-tutorial/)
- [tcp抓包](https://www.cnblogs.com/chenpingzhao/p/9108570.html)
- [mac 切换PHP版本](https://www.php.cn/php-weizijiaocheng-387734.html)
- [发布包到packagist](https://blog.csdn.net/weixin_33896069/article/details/89774893)
- 数组指针和指针数组的区别 [参考1](https://www.cnblogs.com/dan-Blog/articles/8866513.html)&nbsp; &nbsp;[参考2](https://blog.csdn.net/weibo1230123/article/details/81449593)
