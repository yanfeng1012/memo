## 加入金仓PDO扩展

- 编辑php.ini:

		添加:
		extension=/usr/local/php/lib/kingbase/pdo_kdb.so(文件位置)
		
- 设置环境变量

		export LD_LIBRARY_PATH=/usr/local/php/lib/kingbase(文件所在文件夹)

- 测试扩展加载

		php -m | grep pdo_kdb
		
- 启动php-fpm时找不到拓展文件

		1、将人大金仓的拓展放入/etc/ld.so.conf
		/opt/kingbaseES/V8/Server/lib(数据库安装位置)
		
		2、执行/sbin/ldconfig 更新生效
	
- 初始化数据库

	initdb -D /opt/kingbaseES/V8/data --case-insensitive -USYSTEM -W123456

- `ind_in_set` 替换为 `find-string = ANY (string_to_array(some_column,','))` 

- `date-format` 替换为 `to_char`