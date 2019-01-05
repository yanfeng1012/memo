## login_shell

	#!/usr/bin/expect

	set timeout 3
	spawn ssh root@47.92.131.227
	expect "*password*"
	send "123"
	interact