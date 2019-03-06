## mysql8 error

1. MySQL版本8.0.4之后修改密码

		ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '新密码';
		
2. The server quit without updating PID file

		sudo chown -R _mysql /usr/local/var/mysql
		
3. Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)

		mysql 没有正常启动 
		sudo mysql.server start 更新报错解决问题
		
4. sql_mode

		 ONLY_FULL_GROUP_BY 
		 STRICT_TRANS_TABLES
		 NO_ZERO_IN_DATE 
		 NO_ZERO_DATE 
		 ERROR_FOR_DIVISION_BY_ZERO
		 NO_ENGINE_SUBSTITUTION	
		 
5. nginx: [alert] could not open error log file: open() "/usr/local/var/log/nginx/error.log" failed (13: Permission denied)

 		give /usr/local/var/log/nginx/ folder permissions, so nginx can write into it.

6. mysql 1170

	> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;在MySQL数据库中，当创建新表或者更改已存在表，这个表存在主键，并且是unique唯一性约束和索引约束时，或者是在定义一个索引来更改数据表的操作语句的时候，下面的错误信息很可能会出现，并且经过当前操作命令的完成。错误信息为BLOB或者TEXT字段使用了未指定键值长度的键。<br>
	> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;错误发生的原因是因为MySQL只能将BLOB/TEXT类型字段设置索引为BLOB/TEXT数据的钱N个字符，因此错误常常发生在字段被定义为TEXT/BLOB类型或者和TEXT/BLOB同质的数据类型，如TINYTEXT,MEDIUMTEXT,LONGTEXT ,TINYBLOB,MEDIUMBLOB 和LONGBLOB，并且当前操作是将这个字段设置成主键或者是索引的操作。在未指定TEXT/BLOB‘键长’的情况下，字段是变动的并且是动态的大小所以MySQL不能够保证字段的唯一性。因此当使用TEXT/BLOB类型字段做为索引时，N的值必须提供出来才可以让MySQL决定键长，但是MySQL不支持在TEXT/BLOB限制，TEXT(88)是不行的。<br>
	> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当你试图将数据表中的一个非TEXT或者非BLOB类型如VARCHAR或ENUM的字段转换成TEXT/BLOB，同时这个字段已经被定义了unique限制或者是索引，这个错误也会弹出，并且更改数据表的命令会执行失败<br>
	> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;解决方案是将unique限制和索引从TEXT/BLOB字段中移除，或者是设置另一个字段为主键，如果你不愿意这样做并且想在TEXT/BLOB上加限制，那么你可以尝试将这个字段更改为VARCHAR类型，同时给他一个限制长度，默认VARCHAR最多可以限定在255个字符，并且限制要在声明类型的右边指明，如VARCHAR(200)将会限制仅仅200个字符<br>
	> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;有时候，即使你在数据表中不使用TEXT/BLOB类型或者同质类型，error1170 也会出现，这个问题出现在当你设置一个VARCHAR字段为主键，但是却错误的设置了长度或者字符数，事实上，VARCHAR只能接受最大为256个字符串，但是你错误的设置成VARCHAR(512)等一些错误的设置，这些错误的设置会强制MySQL自动将VARCHAR(512)等转换成SMALLINT类型，同时这个字段被设置成primary key ，unique限制或者index索引等，然后执行操作就出现error 1170错误，解决问题的方法，为VARCHAR域指定小于256的长度。