## 银河麒麟安装PHP7.3.6

### 准备

- 下载 PHP

	`地址`[https://www.php.net/downloads.php](https://www.php.net/downloads.php)	
	
- 新增用户组和用户

		[root@localhost php-7.3.6]# groupadd www
		[root@localhost php-7.3.6]# useradd -g www www
		
### 编译安装

- 生成 Makefile 文件

>./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-config-file-scan-dir=/usr/local/php/conf.d --enable-fpm --with-fpm-user=www --with-fpm-group=www --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv-dir --with-freetype-dir=/usr/local/freetype --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-mbregex --enable-mbstring --enable-intl --enable-pcntl --enable-ftp --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --without-libzip 


#### 依赖错误

- libxml build works no

		sudo apt-get install liblzma-dev libzip-dev
		
- curl 7.*.* or greater...

		sudo apt-get install libcurl4-gnutls-dev
		