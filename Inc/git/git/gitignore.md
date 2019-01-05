### demo
	#.gitignore
	/.web-server-pid
	/app/config/parameters.yml
	/build/ 
	/phpunit.xml
	/var/*
	!/var/cache
	/var/cache/*
	!var/cache/.gitkeep
	!/var/logs
	/var/logs/*
	!var/logs/.gitkeep
	!/var/sessions
	/var/sessions/*
	!var/sessions/.gitkeep
	!var/SymfonyRequirements.php
	/vendor/ 忽略vendor下的所有文件
	/web/bundles/
	/.settings 忽略 .settings 文件
	/.buildpath
	/.project
	/
	/src/AdminBundle/Entity/*.php~ 忽略src/AdminBundle/Entity/下的所有后缀名为.php的文件
	*.php~

在项目目录下创建一隐藏文件 .gitignore 将需要忽略的内容编写进文件中

### 解释

	# 此为注释 – 将被 Git 忽略
	*.a       # 忽略所有 .a 结尾的文件
	!lib.a    # 但 lib.a 除外
	/TODO     # 仅仅忽略项目根目录下的 TODO 文件，不包括 subdir/TODO
	build/    # 忽略 build/ 目录下的所有文件
	doc/*.txt # 会忽略 doc/notes.txt 但不包括 doc/server/arch.txt