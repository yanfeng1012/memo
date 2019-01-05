- 检查当前默认设置

		[root@rems2 ~]# systemctl get-default
		graphical.target

	##### graphical.target表示开机将默认进入图形界面 multi-user.target 文本界面

- 设置开机进入文本/图形界面

		root@rems2 ~]# systemctl set-default multi-user.target/graphical.target