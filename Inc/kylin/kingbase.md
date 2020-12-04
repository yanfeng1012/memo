## 加入金仓PDO扩展

- 编辑php.ini文件，分别找到:

		1、extension_ dir= “./”
		修改为:
		extension_ dir = "/opt/php/kingbase/lib"
		2、加入:
		extension=/opt/php/kingbase/lib/pdo_kdb.so
		
- 设置环境变量

		export LD_ LIBRARY_ PATH=/opt/php/kingbase/lib

- 测试扩展加载

		php -m | grep pdo_kdb