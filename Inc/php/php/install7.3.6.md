## 安装 PHP

### 前期准备

- 查看 CentOS 版本信息

		[root@localhost ~]# cat /etc/issue
		CentOS release 7.9 (Final)
		
- 下载 PHP

	`地址`[https://www.php.net/downloads.php](https://www.php.net/downloads.php)	
	
- 新增用户组和用户

		[root@localhost php-7.3.6]# groupadd www
		[root@localhost php-7.3.6]# useradd -g www www
		
- 安装依赖库包

		[root@localhost php-7.3.6]# yum install -y autoconf automake libtool re2c libxml* openssl* BZip2* libcurl* libjpeg* libpng* libXpm* libzip* zlib* freetype* pcre* 
		
### 编译安装

- 生成 Makefile 文件

>./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-config-file-scan-dir=/usr/local/php/conf.d --enable-fpm --with-fpm-user=www --with-fpm-group=www --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv-dir --with-freetype-dir=/usr/local/freetype --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-mbregex --enable-mbstring --enable-intl --enable-pcntl --enable-ftp --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --without-libzip 


#### 依赖错误

- 如果出现下面的错误，表示当前的 libzip 版本过低，因为使用 yum 最新版只到 0.10，不足以达到要求，需要更新版本：

		[root@localhost php-7.3.6]# ./configure ......
		checking for ...
		...
		checking for libzip... configure: error: system libzip must be upgraded to version >= 0.11

- 更新 libzip
先删除旧版本的 libzip 然后手动下载源码编译安装：

		[root@localhost php-7.3.6]# yum remove -y libzip
		[root@localhost php-7.3.6]# wget https://nih.at/libzip/libzip-1.2.0.tar.gz
		[root@localhost php-7.3.6]# tar -zxvf libzip-1.2.0.tar.gz
		[root@localhost php-7.3.6]# ./configure
		[root@localhost php-7.3.6]# make && make install
		
- off_t 未定义

如果出现未定义的类型 off_t 错误的话，off_t 类型是在头文件 unistd.h 中定义的，在 32 位系统编译成 long int，64 位系统则编译成 long long int，在进行编译的时候默认查找 64 位的动态链接库，但是默认情况下 CentOS 的动态链接库配置文件 /etc/ld.so.conf 没有加入搜索路径，所以需要将 /usr/local/lib64 和 /usr/lib64 这些针对 64 位的库文件路径加进去：

	[root@localhost php-7.3.6]# ./configure ......
	checking for ...
	...
	checking size of off_t... 0
	configure: error: off_t undefined; check your library configuration
	
- 添加路径（一般不需要）

先将搜索路径添加进配置文件，然后更新配置（其中 ldconfig -v 是用来更新 ld 的缓存文件 ld.so.cache , 缓存文件的目的是记录动态编译库文件的路径，加快二进制文件运行时的速度）：

	[root@localhost php-7.3.6]# echo '/usr/local/lib64
	/usr/local/lib
	/usr/lib
	/usr/lib64'>>/etc/ld.so.conf
	[root@localhost php-7.3.6]# ldconfig -v
	
- `缺少 BZip2`

如果出现提示需要重装 BZip2 ，需要安装 bzip2 和 bzip2-devel 。

	configure: error: Please reinstall the BZip2 distribution

解决方式：

	[root@localhost php-7.3.6]# yum install -y bzip2 bzip2-devel

- 安装扩展 GD 报错

如果在安装 GD 时出现提示缺少 webp/decode.h ，需要安装 libwebp 和 libwebp-devel 。

	checking whether to enable JIS-mapped Japanese font support in GD... yes
	configure: error: webp/decode.h not found.

解决方式：

	[root@localhost php-7.3.6]# yum install -y libwebp libwebp-devel
	
### 编译

	[root@localhost php-7.3.6]# make && make install
	
### 复制配置文件

	[root@localhost php-7.3.6]# cp php.ini-production /usr/local/php/etc/php.ini
	[root@localhost php-7.3.6]# mv /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
	
### 配置php-fpm.conf

- 启动 php-fpm 时报错内容

		[root@localhost sbin] ERROR: No pool defined. at least one pool section must be specified in config file
		[root@localhost sbin] ERROR: failed to post process the configuration
		[root@localhost sbin] ERROR: FPM initialization failed
		
- php-fpm配置文件内容（有效配置就三行）：

		error_log = /usr/local/var/log/php-fpm.log
		pid = /usr/local/var/run/php-fpm.pid

	
