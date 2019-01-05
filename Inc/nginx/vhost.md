#### lnmp1.4 nginx/conf/enable-php-pathinfo-sf.conf

	  location / {
	          try_files $uri /app.php$is_args$args;
	  }
	  # PROD
	  location ~^/app\.php(/|$)
	  {
	      fastcgi_pass  unix:/tmp/php-cgi.sock;
	      fastcgi_index index.php;
	      include fastcgi.conf;
	      include pathinfo.conf;
	      internal;
	  }
	  #DEV 
	  location ~^/(app_dev|config)\.php(/|$) 
	  { 
	      fastcgi_pass  unix:/tmp/php-cgi.sock;
	      fastcgi_index index.php;
	      include fastcgi.conf;
	      include pathinfo.conf;
	  }

#### PS：open_basedir配置问题，修改fastcgi.conf

	  fastcgi_param  SCRIPT_FILENAME    $document_root    $fastcgi_script_name;
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
	  #原有配置为$document_root/ 改为 $document_root/../
	  #fastcgi_param PHP_ADMIN_VALUE "open_basedir=$document_root/:/tmp/:/proc/"; 
	  fastcgi_param PHP_ADMIN_VALUE "open_basedir=$document_root/../:/tmp/:/proc/";

### 独立的vhost配置文件

	 	server{
      		listen 80;
      		#listen [::]:80;
		    server_name symfony.kitlabs.cn;
		    index index.html index.htm index.php default.html default.htm default.php;
		    root  /home/wwwroot/symfony.kitlabs.cn/web;
		
		    include other.conf;  
			include enable-php-pathinfo.conf（原文件为enable-php.conf）
			#在nginx默认配置中不包含pathinfo模式，需要添加一个配置项来支持pathinfo
			#在nginx/conf中自带enable-php-pathinfo.conf （直接引用即可）
		    #error_page   404   /404.html;
		
		    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
		    {
		        expires      30d;
		    }
		
		    location ~ .*\.(js|css)?$
		    {
		        expires      12h;
		    }
		
		    location / {
		        # try to serve file directly, fallback to app.php
		        try_files $uri /app.php$is_args$args;
		    }
		    # DEV
		    # This rule should only be placed on your development environment
		    # In production, don't include this and don't deploy app_dev.php or config.php
  			location ~ ^/(app_dev|config)\.php(/|$) {

              	fastcgi_pass  unix:/tmp/php-cgi.sock;
              	fastcgi_split_path_info ^(.+\.php)(/.*)$;
          		include fastcgi_params;
              	# When you are using symlinks to link the document root to the
              	# current version of your application, you should pass the real
              	# application path instead of the path to the symlink to PHP
              	# FPM.
              	# Otherwise, PHP's OPcache may not properly detect changes to
              	# your PHP files (see https://github.com/zendtech/ZendOptimizerPlus/issues/126
              	# for more information).
              	fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
              	fastcgi_param DOCUMENT_ROOT $realpath_root;
      		}
      		# PROD
	      	location ~ ^/app\.php(/|$) {
	              fastcgi_pass  unix:/tmp/php-cgi.sock;
	              fastcgi_split_path_info ^(.+\.php)(/.*)$;
	              include fastcgi_params;
	              # When you are using symlinks to link the document root to the
	              # current version of your application, you should pass the real
	              # application path instead of the path to the symlink to PHP
	              # FPM.
	              # Otherwise, PHP's OPcache may not properly detect changes to
	              # your PHP files (see https://github.com/zendtech/ZendOptimizerPlus/issues/126
	              # for more information).
	              fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
	              fastcgi_param DOCUMENT_ROOT $realpath_root;
	              # Prevents URIs that include the front controller. This will 404:
	              # http://domain.tld/app.php/some-path
	              # Remove the internal directive to allow URIs like this
	              internal;
	      }

	      # return 404 for all other php files not matching the front controller
	      # this prevents access to other php files you don't want to be accessible.
	      location ~ \.php$ {
	              return 404;
	      }
	      access_log  /home/wwwlogs/symfony.kitlabs.cn.log  access;
  	}