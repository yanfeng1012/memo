## shell login
		
	#!/usr/bin/expect
	
	set timeout 3
	spawn ssh root@ip地址 
	expect "*password*"
	send "yourpassword"
	interact
	
- ps: 默认端口 22 如需更改 将`spawn ssh root@ip地址 ` 变更为`spawn ssh root@ip地址 -p 8080`	
	