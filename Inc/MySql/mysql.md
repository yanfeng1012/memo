## mysql 语法汇总（持续补充...）

- 创建MySQL用户账号


		GRANT ALL ON cookbook.* TO 'cbuser'@'localhost' IDENTIFIED BY 'cbpass';
		
- 创建数据库和样表

		CREATE DATABASE cookbook;
		
- DATE_FORMAT()

		DATE_FORMAT(date,'%b %d %Y %h:%i %p')
		
- MySQL导出
	
        mysqldump -u 用户名 -p dbname > dbname.sql
        
- mysql 外键
      
        SET FOREIGN_KEY_CHECKS=0; //取消外键
        SET FOREIGN_KEY_CHECKS=1; //启用外键