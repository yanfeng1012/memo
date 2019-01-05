- 查看MYSQL数据库中所有用户

		SELECT DISTINCT CONCAT('User: ''',user,'''@''',host,''';') AS query FROM mysql.user;

###  一. 创建用户

#### 命令:

		CREATE USER 'username'@'host' IDENTIFIED BY 'password';

##### 说明：

- username：你将创建的用户名
- host：指定该用户在哪个主机上可以登陆，如果是本地用户可用localhost，如果想让该用户可以从任意远程主机登陆，可以使用通配符%
- password：该用户的登陆密码，密码可以为空，如果为空则该用户可以不需要密码登陆服务器

		例子：
		CREATE USER 'dog'@'localhost' IDENTIFIED BY '123456';
		CREATE USER 'pig'@'192.168.1.101_' IDENDIFIED BY '123456';
		CREATE USER 'pig'@'%' IDENTIFIED BY '123456';
		CREATE USER 'pig'@'%' IDENTIFIED BY '';
		CREATE USER 'pig'@'%';

### 设置与更改用户密码

- 命令:

		SET PASSWORD FOR 'username'@'host' = PASSWORD('newpassword');

##### 如果是当前登陆用户用:

	SET PASSWORD = PASSWORD("newpassword");

##### 例子:

	SET PASSWORD FOR 'pig'@'%' = PASSWORD("123456");

### 删除用户

#### 命令:

	DROP USER 'username'@'host';