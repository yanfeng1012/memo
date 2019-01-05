## lnmp一键安装步骤

1.下载

 - 下载地址  [lnmp.org](https://lnmp.org)
	    LNMP 1.4
	
		下载版：(不含源码安装包文件，仅有安装脚本及配置文件)
		http://soft.vpser.net/lnmp/lnmp1.4.tar.gz  (134KB)
		MD5: 223585139fb613f47990b1b41979adea
		
		完整版：
		国内：http://soft1.vpser.net/lnmp/lnmp1.4-full.tar.gz  (467MB)
		国外：http://soft2.vpser.net/lnmp/lnmp1.4-full.tar.gz  (467MB)
		MD5: f1121dbf903e02f2e98987f6cabd5198
		下载完建议先验证MD5。

2.安装

		安装步骤:
		1、使用putty或类似的SSH工具登陆VPS或服务器（xshell 5 ）；
		
		登陆后运行：screen -S lnmp
		如果提示screen: command not found 命令不存在可以执行：yum install screen 或 apt-get install screen安装，详细内容参考screen教程。
		
		2、下载并安装LNMP一键安装包：
		
		安装LNMP稳定版
		
		wget -c http://soft.vpser.net/lnmp/lnmp1.4.tar.gz && tar zxf lnmp1.4.tar.gz && cd lnmp1.4 && ./install.sh lnmp
		
		默认安装lnmp可不写，如需要安装LNMPA或LAMP，将./install.sh 后面的参数替换为lnmpa或lamp即可。如需更改网站和数据库目录先修改安装包目录下的 lnmp.conf 文件。
		
		目前提供了较多的MySQL、MariaDB版本和不安装数据库的选项，需要注意的是MySQL 5.6,5.7及MariaDB 10必须在1G以上内存的更高配置上才能选择！
		
		输入对应MySQL或MariaDB版本前面的序号，回车进入下一步.

		询问是否需要启用MySQL InnoDB，InnoDB引擎默认为开启，一般建议开启，直接回车或输入 y ，如果确定确实不需要该引擎可以输入 n，输入完成，回车进入下一步。

		注意：选择PHP7等高版本时需要自行确认是否与自己的程序兼容。

		输入要选择的PHP版本的序号，回车进入下一步，选择是否安装内存优化：
		
		提示"Press any key to install...or Press Ctrl+c to cancel"后，按回车键确认开始安装。 
		LNMP脚本就会自动安装编译Nginx、MySQL、PHP、phpMyAdmin、Zend Optimizer这几个软件。
		
		安装时间可能会几十分钟到几个小时不等，主要是机器的配置网速等原因会造成影响。
		
		3、安装完成
		如果显示Nginx: OK，MySQL: OK，PHP: OK
		并且Nginx、MySQL、PHP都是running，80和3306端口都存在，并提示安装使用的时间及Install lnmp V1.4 completed! enjoy it.的话，说明已经安装成功。
		
		安装完成接下来开始使用就可以了，按添加虚拟主机教程，添加虚拟主机后可以使用sftp或ftp服务器上传网站代码，将域名解析到VPS或服务器的IP上，解析生效即可使用。
		
		默认LNMP是不安装FTP服务器的，如需要FTP服务器：https://lnmp.org/faq/ftpserver.html
		
		5、添加、删除虚拟主机及伪静态管理
		https://lnmp.org/faq/lnmp-vhost-add-howto.html
		
		6、eAccelerator、xcache、memcached、imageMagick、ionCube、redis、opcache的安装
		https://lnmp.org/faq/addons.html
		
		7、LNMP相关软件目录及文件位置
		https://lnmp.org/faq/lnmp-software-list.html
		
		8、LNMP状态管理命令
		https://lnmp.org/faq/lnmp-status-manager.html
		
		9、仅安装数据库、Nginx
		lnmp 1.4开始支持只安装MySQL/MariaDB数据库或Nginx
		增加单独nginx安装，安装包目录下运行：./install.sh nginx 进行安装；
		增加单独数据库安装，安装包目录下运行：./install.sh db 进行安装；