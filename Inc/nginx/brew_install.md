## mac brew install lnmp 环境

1. PHP

	- 安装

			brew install php （默认安装当前最稳定版本）
			
	- 配置PHP及php-fpm

		`php`, `phpize`, `php-config` 
		
			/usr/local/opt/php/bin
				
		`php-fpm` 
		
			/usr/local/opt/php/sbin/php-fpm
			
		`php.ini` 
		
			/usr/local/etc/php/7.3.1/php.ini 
			
		`php-fpm.conf` 
		
			/usr/local/etc/php/7.3.1/php-fpm.conf
			
	- 添加php-fpm为开机启动项

			$ cp /usr/local/opt/php/homebrew.mxcl.php.plist ~/Library/LaunchAgents/
			$ launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php.plist
			
	- 安装扩展

			pecl install redis
			
2. nginx

	- 安装

			brew install nginx
			
	- 添加nginx为开机启动项
		
			$ cp /usr/local/Cellar/nginx/1.10.2_1/homebrew.mxcl.nginx.plist ~/Library/LaunchAgents/
			$ launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
			
	- nginx的操作命令

			// 启动nginx
			sudo nginx
			
			// 重新加载配置|重启|停止|退出 nginx
			nginx -s reload|reopen|stop|quit
			
			// 测试配置是否有语法错误
			nginx -t
			
	- nginx.conf

		
			user  yanfeng admin; //确定文件所有者和所属组
			worker_processes  1;
			
			#pid        logs/nginx.pid;
			
			events {
			    worker_connections  1024;
			}
			
			http {
			    include       mime.types;
			    default_type  application/octet-stream;
			
			    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
			    #                  '$status $body_bytes_sent "$http_referer" '
			    #                  '"$http_user_agent" "$http_x_forwarded_for"';
			
			    #access_log  logs/access.log  main;
			    #error_log  logs/error.log;
			    #error_log  logs/error.log  notice;
			    #error_log  logs/error.log  info;
			
			    sendfile        on;
			    #tcp_nopush     on;
			
			    #keepalive_timeout  0;
			    keepalive_timeout  65;
			
			    #gzip  on;
			
			    server {
			        listen       80;
			        server_name  localhost;
			
			        #charset koi8-r;
			
			        #access_log  logs/host.access.log  main;
			
			        location / {
			            root   html;
			            index  index.html index.htm index.php;
			        }
			
			        #error_page  404              /404.html;
			
			        # redirect server error pages to the static page /50x.html
			        #
			        error_page   500 502 503 504  /50x.html;
			        location = /50x.html {
			            root   html;
			        }
			
			        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
			        #
			        #location ~ \.php$ {
			        #    proxy_pass   http://127.0.0.1;
			        #}
			
			        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
			        #
			        location ~ \.php$ {
			            root           html;
			            fastcgi_pass   127.0.0.1:9000;
			            fastcgi_index  index.php;
			            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name; //原为$realpath_root 更改为$document_root
			            include        fastcgi_params;
			        }
			    }
			    include servers/*;
			}

		- pathinfo.conf(新增)

				fastcgi_split_path_info ^(.+?\.php)(/.*)$;
				set $path_info $fastcgi_path_info;
				fastcgi_param PATH_INFO       $path_info;
				try_files $fastcgi_script_name =404;
				
		- enable-php-pathinfo-sf.conf(新增)

						location / {
				            try_files $uri /app.php$is_args$args;
				        }
				        # PROD
				        location ~^/app\.php(/|$)
				        {
				            fastcgi_pass   127.0.0.1:9000;
				            fastcgi_index index.php;
				            include fastcgi.conf;
				            include pathinfo.conf;
				            internal;
				        }
				        #DEV
				        location ~^/(app_dev|config)\.php(/|$)
				        {
				            fastcgi_pass   127.0.0.1:9000;
				            fastcgi_index index.php;
				            include fastcgi.conf;
				            include pathinfo.conf;
				        }
				        
        - fastcgi.conf

        	
				fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
				fastcgi_param  QUERY_STRING       $query_string;
				fastcgi_param  REQUEST_METHOD     $request_method;
				fastcgi_param  CONTENT_TYPE       $content_type;
				fastcgi_param  CONTENT_LENGTH     $content_length;
				
				fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
				fastcgi_param  REQUEST_URI        $request_uri;
				fastcgi_param  DOCUMENT_URI       $document_uri;
				fastcgi_param  DOCUMENT_ROOT      $document_root;
				fastcgi_param  SERVER_PROTOCOL    $server_protocol;
				fastcgi_param  REQUEST_SCHEME     $scheme;
				fastcgi_param  HTTPS              $https if_not_empty;
				
				fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
				fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;
				
				fastcgi_param  REMOTE_ADDR        $remote_addr;
				fastcgi_param  REMOTE_PORT        $remote_port;
				fastcgi_param  SERVER_ADDR        $server_addr;
				fastcgi_param  SERVER_PORT        $server_port;
				fastcgi_param  SERVER_NAME        $server_name;
				
				# PHP only, required if PHP was built with --enable-force-cgi-redirect
				fastcgi_param  REDIRECT_STATUS    200;
				fastcgi_param PHP_ADMIN_VALUE "open_basedir=$document_root/../:/tmp/:/proc/";//新增这一字段（因为symfony 的 open_dir问题）

			
3. MySQL 

	- 安装

			brew install mysql
			
	- mysql操作命令

			brew services start|stop|restart mysql
			
4. redis

	- 安装

			brew install redis 
			brew services start|stop|restart redis
			