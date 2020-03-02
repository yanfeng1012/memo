## mysql

1. [mysql 语法汇总](/Inc/MySql/inc/mysql.md)
2. [grant 授权](/Inc/MySql/inc/grant.md)
3. [创建用户（user）](/Inc/MySql/inc/user.md)
4. [confguire](/Inc/MySql/inc/confguire.md)
5. [sql_mode](/Inc/MySql/inc/sql_mode.md)
6. [update root password](/Inc/MySql/inc/update_root_password.md)
7. [mysql query](/Inc/MySql/inc/query.md)&nbsp;&nbsp;&nbsp;&nbsp;MySQL查询当天、本周、本月、上一个月的数据
8. [find_in_set()](/Inc/MySql/inc/find_in_set.md) &nbsp;&nbsp;&nbsp;&nbsp; MySQL中find_in_set()函数的使用
9. [mysql 主从配置](/Inc/MySql/inc/master-slave.md)
10. [mysql log config](/Inc/MySql/inc/log-config.md)
11. [mysql8 errors](/Inc/MySql/inc/mysql8.md)
12. mysql 外键
      
        SET FOREIGN_KEY_CHECKS=0; //取消外键
        SET FOREIGN_KEY_CHECKS=1; //启用外键
        
13. [mysql 关键字和保留字](https://dev.mysql.com/doc/refman/8.0/en/keywords.html)
14. MySQL导出

        mysqldump -u 用户名 -p dbname > dbname.sql

15. [mysql 数据去重](https://blog.csdn.net/n950814abc/article/details/82284838)
16. [mysql bin_log](/Inc/MySql/inc/binlog.md)
17. [linux 安装 MySQL 5.7.26](/Inc/MySql/inc/install5.7.26.md)
18. [linux 安装 MySQL 8.0.16](/Inc/MySql/inc/install8.0.16.md)
19. [mysql 主从 error 1032](https://blog.51cto.com/suifu/1845457)
20. [into outfile](https://www.jianshu.com/p/da3d8e8de237)
21. [mysql 1093](https://blog.csdn.net/qq_33674639/article/details/78875082)
22. 清空表/截断表

	清空表：`delete from users`

	>清空表只是清空表中的逻辑数据，但是物理数据不清除，如主键值、索引等不被清除，还是原来的值。

	截断表：`truncate table users`

	>截断表可以用于删除表中 的所有数据。截断表命令还会回收所有索引的分配页。截断表的执行速度与不带where子句的delete（删除）命令相同，甚至比它还要快。 delete（删除）一次删除一行数据，并且将每一行被删除的数据都作为一个事务记录日志；而truncate （截断）表则回收整个数据页，只记录很少的日志项。delete（删除）和truncate（截断）都会回收被数据占用的空间，以及相关的索引。只有表的 拥有者可以截断表。

	>另外，truncate表之后，如果有自动主键的话，会恢复成默认值。
	
23. 慢日志

		  # slow query log
		  slow_query_log_file = "/usr/local/mysql/query_slow.log" 
		  slow_query_log = 1 
		  long_query_time = '0.8'  