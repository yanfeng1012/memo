## Get Real IP 

[参考1](https://blog.csdn.net/weixin_34254823/article/details/92356231) [参考2](https://www.jianshu.com/p/0309cb5e7e76) [参考3](https://symfony.com/doc/3.4/deployment/proxies.html)

### 编译Nginx

- 查看Nginx版本及其编译参数

		[root@sft-sqjz-app-01 sbin]# ./nginx -V
		nginx version: nginx/1.16.1
		built by gcc 4.4.7 20120313 (Red Hat 4.4.7-23) (GCC) 
		built with OpenSSL 1.1.1b  26 Feb 2019
		TLS SNI support enabled
		configure arguments: --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_v2_module --with-http_gzip_static_module --with-http_sub_module --with-stream --with-stream_ssl_module --with-openssl=/root/lnmp1.6-full/src/openssl-1.1.1b --with-openssl-opt=enable-weak-ssl-ciphers
		
- 重新编译Nginx 增加 `--with-http_realip_module` 编译参数

		[root@sft-sqjz-app-01 ~]# cd ~/nginx-1.16.1
		[root@sft-sqjz-app-01 nginx-1.16.1]# ./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_v2_module --with-http_gzip_static_module --with-http_sub_module --with-stream --with-stream_ssl_module --with-openssl=/root/lnmp1.6-full/src/openssl-1.1.1b --with-openssl-opt=enable-weak-ssl-ciphers --with-http_realip_module

- 编译Nginx

		[root@sft-sqjz-app-01 nginx-1.16.1]# make
		
		make完之后在objs目录下就多了个nginx文件，这个就是新版本的程序了
		
- 备份旧的nginx程序

		cp /usr/local/nginx/sbin/nginx /usr/local/nginx/sbin/nginx.bak
		
- 把新的nginx程序覆盖旧的

		cp objs/nginx /usr/local/nginx/sbin/nginx
		
- 测试新的nginx程序是否正确

		/usr/local/nginx/sbin/nginx -t
		
		nginx: theconfiguration file /usr/local/nginx/conf/nginx.conf syntax is ok
		
		nginx:configuration file /usr/local/nginx/conf/nginx.conf test issuccessful
		
- 修改 nginx 配置文件
               
		http
		     {
		       ...
			real_ip_header X-Frowarded-For;
			set_real_ip_from 192.168.124.28;
			real_ip_recursive on;

			log_format access '$remote_addr - $remote_user [$time_local] "$request" '
					  '$status $body_bytes_sent "$http_referer" '
					  '"$http_user_agent" "$http_x_forwarded_for"';
		       ...
		     }
		
- 重启Nginx

	- 查看进程号
	
			ps -ef|grep nginx
			
	- 杀死进程

			kill -QUIT 2072（进程号）
			
	- 启动Nginx

			nginx
			
## haproxy

- 修改haproxy配置文件

		defaults
    		...
    		option httpclose 
    		option forwardfor
    		
- 重启haproxy


	- 查看进程号
	
			ps -ef|grep haproxy
			
	- 杀死进程

			kill -9 3335(进程号)			
	- 启动haproxy

			/usr/local/haproxy/sbin/haproxy -f /usr/local/haproxy/haproxy.cfg


## symfony配置

- 修改 app.php

		// tell Symfony about your reverse proxy
		Request::setTrustedProxies(
		    // the IP address (or range) of your proxy
		    ['127.0.0.1', '192.168.124.28'],
		
		    // trust *all* "X-Forwarded-*" headers
		    Request::HEADER_X_FORWARDED_ALL
		
		    // or, if your proxy instead uses the "Forwarded" header
		    // Request::HEADER_FORWARDED
		
		    // or, if you're using AWS ELB
		    // Request::HEADER_X_FORWARDED_AWS_ELB
		);
