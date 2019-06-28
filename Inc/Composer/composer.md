##  更新报错：SSL/TLS

	在项目下执行：
	composer update

	报错 
	[Composer\Exception\NoSslException] 
	The openssl extension is required for SSL/TLS protection but is not available. 
	If you can not enable the openssl extension, you can disable this error, at your own risk, 
	by setting the ‘disable-tls’ option to true. 

	解决方法： 
	进入php.ini 修改配置打开ssl
	
	//将这行代码前的 ; 去掉
	extension=php_openssl.dll 

## 忽略版本

- PHP 7版本太高，不符合composer.json需要的版本，但是在PHP 7下应该也是可以运行的
- composer可以设置忽略版本匹配，命令是：

		1. composer install --ignore-platform-reqs
		
		2. composer update --ignore-platform-reqs

再次执行composer命令可以正常安装包了。

##  Laravel China 维护的 全量镜像

- 选项一、全局配置（推荐）

		$ composer config -g repo.packagist composer https://packagist.laravel-china.org

- 选项二、单独使用

 - 如果仅限当前工程使用镜像，去掉 -g 即可，如下：

	$ composer config repo.packagist composer https://packagist.laravel-china.org
	
## composer 配置parameters.yml不默认生成

- 第一种办法

		  "incenteev-parameters": {
		      "file": "app/config/parameters.yml",
		      "keep-outdated": true //add this option
		  },
		  
- 第二种办法(移除相关引用)

		  "Incenteev\\ParameterHandler\\ScriptHandler::buildParameters",
		  "incenteev/composer-parameter-handler": "~2.0",
		  ...
		
		  "incenteev-parameters": {
		      "file": "app/config/parameters.yml"
		  },
		  
## Linux安装composer

	wget https://dl.laravel-china.org/composer.phar -O /usr/local/bin/composer
	chmod a+x /usr/local/bin/composer
	
### 禁用https

	composer config -g secure-http false