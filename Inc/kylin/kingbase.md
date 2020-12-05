## 加入金仓PDO扩展

- 编辑php.ini文件，分别找到:

		1、extension_dir= “./”
		修改为:
		extension_dir = "/usr/local/php/lib/kingbase"
		2、加入:
		extension=/usr/local/php/lib/kingbase/pdo_kdb.so
		
- 设置环境变量

		export LD_LIBRARY_PATH=/usr/local/php/lib/kingbase

- 测试扩展加载

		php -m | grep pdo_kdb