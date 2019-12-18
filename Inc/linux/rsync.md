## rsync

- 卸载系统自带rsync

  		# yum remove rsync
  	
- 安装 下载最新源码包：https://rsync.samba.org/

		  # tar -zxvf rsync-3.1.2.tar.gz  
		  # cd rsync-3.1.2  
		  # ./configure --prefix=/usr/local/rsync --disable-ipv6  
		  #  make && make install  
		
		  # ln -s /usr/local/rsync/bin/rsync /usr/local/bin/rsync  
		server端配置(172.18.1.13,文件备份端)

- 创建服务端配置文件

  		# vim /usr/local/rsync/rsyncd.conf  

		    #pid文件
		    pid file = /var/run/rsyncd.pid
		    port = 14874
		    #启动用户
		    uid = root
		    #启动用户组
		    gid = root
		    use chroot = no
		    #最大连接数
		    max connections = 5
		    timeout 600
		    #指定lock文件
		    lock file = /var/run/rsyncd.lock
		    #日志文件
		    log file = /var/run/rsyncd.log
		    secrets file = /usr/local/rsync/rsyncd.secrets
		    #指定欢迎消息文件
		    motd file = /usr/local/rsync/rsyncd.motd
		
		    [adjust_code]
		    path = /mnt1/wwwroot/adjust/code
		    ignore errors
		    read only = false
		    list = false
		    hosts allow = 172.168.1.25
		    #hosts deny = 0.0.0.0/32
		    auth users root
		    comment = adjust_code
		
		    [adjust_db]
		    path = /mnt1/wwwroot/adjust/db
		    ignore errors
		    read only = false
		    list = false
		    hosts allow = 172.168.1.26
		    #hosts deny = 0.0.0.0/32
		    auth users root
		    comment = adjust_db
    
- 创建服务端欢迎文件

		  #vi /usr/local/rsync/rsyncd.motd  
		
		  ++++++++++++++++++++++++++++++++++++  
		  Wlecome to  rsync services         
		  ++++++++++++++++++++++++++++++++++++  
  
- 指定rsync访问的密码（密码不需要和系统账号密码相同）

		  # vi /usr/local/rsync/rsyncd.secrets    
		  root:test@0256  
		  //设置文件权限、所属用户
		  # chmod 600 /usr/local/rsync/rsyncd.secrets  
		  # chown root:root /usr/local/rsync/rsyncd.secrets
		  //建立软链接
		  ln -s /usr/local/rsync/rsyncd.conf /etc/rsyncd.conf  
		  ln -s /usr/local/rsync/rsyncd.motd /etc/rsyncd.motd  
		  ln -s /usr/local/rsync/rsyncd.secrets  /etc/rsyncd.secrets 
		启动rsync
		
		  # /usr/local/bin/rsync --daemon --config=/etc/rsyncd.conf
		  # echo "/usr/local/bin/rsync --daemon --config=/etc/rsyncd.conf" >> /etc/rc.d/rc.local
		  # cat /etc/rc.d/rc.local
		      #!/bin/sh
		      #  
		      # This script will be executed *after* all the other init scripts.  
		      # You can put your own initialization stuff in here if you don't  
		      # want to do the full Sys V style init stuff.  
		      /usr/local/bin/rsync --daemon --config=/etc/rsyncd.conf
		      
- 客户端服务器配置

	- 新建客户端密码文件(客户端不带用户名)

			  #vim /usr/local/rsync/rsyncd.secrets
			  test@0256
			  # chmod 600 /usr/local/rsync/rsyncd.secrets
			  
	- 新建同步脚本（推）

			  # vi /rsync.sh
			  #!/bin/bash
			
			  rsync -avzH --progress --delete --password-file=/usr/local/rsync/rsyncd.secrets /home/wwwroot/wateroa/ root@172.18.1.13::wateroa_code
			  
	- 自动同步:每隔五分钟同步一次

			  # crontab -e
			  */5 * * * * /rsync.sh