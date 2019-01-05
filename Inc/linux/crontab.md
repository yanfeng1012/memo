## crontab&nbsp;&nbsp;&nbsp;&nbsp;[参考](http://www.cnblogs.com/zoulongbin/p/6187238.html)

- 命令概念

	1. crontab命令用于设置周期性被执行的指令。该命令从标准输入设备读取指令，并将其存放于“crontab”文件中，以供之后读取和执行。
	
	2. cron 系统调度进程。 可以使用它在每天的非高峰负荷时间段运行作业，或在一周或一月中的不同时段运行。cron是系统主要的调度进程，可以在无需人工干预的情况下运行作业。
	
	3. crontab命令允许用户提交、编辑或删除相应的作业。每一个用户都可以有一个crontab文件来保存调度信息。系统管理员可以通过/etc/cron.deny 和 /etc/cron.allow 这两个文件来禁止或允许
	
	4. 用户拥有自己的crontab文件。

- 检查是否安装了crontab

		[root@iZ2zeg2hqiikgrvgmml0zwZ cheng.kitcloud.cn]# rpm -qa | grep crontab
		crontabs-1.10-33.el6.noarch
	
-  crontab服务启动与关闭

		/etc/init.d/crond start     启动服务
		/etc/init.d/crond stop      停止服务
		/etc/init.d/crond restart   重启服务
		/etc/init.d/crond reload    重新载入配置
		
- 全局配置文件

`crontab`在`/etc`目录下面存在`cron.hourly`,`cron.daily`,`cron.weekly`,`cron.monthly`,`cron.d`五个目录和`crontab`,`cron.deny`二个文件。

	cron.daily是每天执行一次的job
	
	cron.weekly是每个星期执行一次的job
	
	cron.monthly是每月执行一次的job
	
	cron.hourly是每个小时执行一次的job
	
	cron.d是系统自动定期需要做的任务
	
	crontab是设定定时任务执行文件
	
	cron.deny文件就是用于控制不让哪些用户使用Crontab的功能
	
- 用户配置文件

	>**每个用户都有自己的`cron`配置文件,通过`crontab -e` 就可以编辑,
	一般情况下我们编辑好用户的cron配置文件保存退出后,系统会自动就存放于`/var/spool/cron/`目录中,文件以用户名命名.
	linux的cron服务是每隔一分钟去读取一次`/var/spool/cron,/etc/crontab,/etc/cron.d`下面所有的内容.**
	
- crontab文件格式

		  *       *       *      *      *        command
		
		minute   hour    day   month   week      command
		
		  分      时      天     月      星期       命令
		  
	- eg:
		  
			[root@iZ2zeg2hqiikgrvgmml0zwZ etc]# more /etc/crontab
			SHELL=/bin/bash
			PATH=/sbin:/bin:/usr/sbin:/usr/bin
			MAILTO=root
			HOME=/
			
			# For details see man 4 crontabs
			
			# Example of job definition:
			# .---------------- minute (0 - 59)
			# |  .------------- hour (0 - 23)
			# |  |  .---------- day of month (1 - 31)
			# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
			# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
			# |  |  |  |  |
			# *  *  *  *  * user-name command to be executed
			  
		    minute： 表示分钟，可以是从0到59之间的任何整数。
	
			hour：表示小时，可以是从0到23之间的任何整数。
			
			day：表示日期，可以是从1到31之间的任何整数。
			
			month：表示月份，可以是从1到12之间的任何整数。
			
			week：表示星期几，可以是从0到7之间的任何整数，这里的0或7代表星期日。
			
			command：要执行的命令，可以是系统命令，也可以是自己编写的脚本文件。
			
- 特殊字符

		星号（*）：代表每的意思，例如month字段如果是星号，则表示每月都执行该命令操作。
		
		逗号（,）：表示分隔时段的意思，例如，“1,3,5,7,9”。
		
		中杠（-）：表示一个时间范围，例如“2-6”表示“2,3,4,5,6”。
		
		正斜线（/）：可以用正斜线指定时间的间隔频率，例如“0-23/2”表示每两小时执行一次。同时正斜线可以和星号一起使用，例如*/10，如果用在minute字段，表示每十分钟执行一次。	
		
- 列出crontab文件

		crontab -l
		
 可以使用这种方法在$HOME目录中对crontab文件做一备份:
 
		crontab -l > $HOME/mycron
		
- 编辑crontab文件

	首先要设置环境变量EDITOR。cron进程根据它来确定使用哪个编辑器编辑crontab文件。
编辑$HOME目录下的. profile文件，在其中加入这样一行(使用vi):

		EDITOR=vi; export EDITOR
		
	- 编辑命令：

			 crontab -e
			 
- 删除crontab文件

 		crontab -r
 		
- 按时间记录执行的log

		  * * * * * php /home/wwwroot/oa/bin/console admin:sms:send >> /home/wwwlogs/sms/`date +\%Y\%m\%d\%H`_sms.log 2>&1
		  * * * * * php /home/wwwroot/oa/bin/console admin:sms:send >> "/home/wwwlogs/sms/$(date +"\%Y\%m\%d\%H")_sms.log" 2>&1
		  
	PS:2>&1 表示把标准错误输出重定向到与标准输出一致	
	

