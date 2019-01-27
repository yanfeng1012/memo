## mysql8 error

1. MySQL版本8.0.4之后修改密码

		ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '新密码';
		
2. The server quit without updating PID file

		sudo chown -R _mysql /usr/local/var/mysql
		
3. Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)

		mysql 没有正常启动 
		sudo mysql.server start 更新报错解决问题	