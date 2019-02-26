## open_basedir

- Warning: require(): open_basedir restriction in effect. 

		#open basic dir
		#fastcgi_param PHP_ADMIN_VALUE "open_basedir=$document_root/../:/tmp/:/proc/";
		fastcgi_param PHP_ADMIN_VALUE "open_basedir=$document_root/../:/tmp/:/proc/`:/var`";//新增:/var
	
