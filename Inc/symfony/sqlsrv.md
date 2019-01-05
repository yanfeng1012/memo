## php安装sqlsrv扩展

- 下载<br>
  下载地址：<a href="https://github.com/Microsoft/msphpsql/releases">https://github.com/Microsoft/msphpsql/releases</a>
	
- 配置（php.ini）

		extension=php_sqlsrv_72_ts.dll
	  	extension=php_pdo_sqlsrv_72_ts.dll

- 测试

	php -m | grep "sqlsrv"
 