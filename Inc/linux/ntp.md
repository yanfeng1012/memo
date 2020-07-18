## linux下ntp时间服务器的搭建与配置

- 第一步，安装NTP服务:

	- rpm -ivh ntp-4.2.2p1-8.el5.centos.1.rpm

	- yum install -y ntp ntpdate

- 第二步，配置NTP服务：

	编辑配置文件/etc/ntp.conf 

		# Permit time synchronization with our time source, but do not
		# permit the source to query or modify the service on this system.
		restrict default kod nomodify notrap nopeer noquery
		restrict -6 default kod nomodify notrap nopeer noquery
		# Permit all access over the loopback interface.  This could
		# be tightened as well, but to do so would effect some of
		# the administrative functions.
		restrict 127.0.0.1
		restrict -6 ::1
		restrict 192.168.20.0 mask 255.255.255.0 nomodify notrap
		restrict 192.168.50.0 mask 255.255.255.0 nomodify notrap
		# Hosts on local network are less restricted.
		#restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap
		
		# Use public servers from the pool.ntp.org project.
		# Please consider joining the pool (http://www.pool.ntp.org/join.html).
		server 0.centos.pool.ntp.org iburst
		server 1.centos.pool.ntp.org iburst
		server 2.centos.pool.ntp.org iburst
		server 3.centos.pool.ntp.org iburst
		
		#broadcast 192.168.1.255 autokey        # broadcast server
		#broadcastclient                        # broadcast client
		#broadcast 224.0.1.1 autokey            # multicast server
		#multicastclient 224.0.1.1              # multicast client
		#manycastserver 239.255.254.254         # manycast server
		#manycastclient 239.255.254.254 autokey # manycast client
		
		# Enable public key cryptography.
		#crypto
		
		includefile /etc/ntp/crypto/pw
		
		# Key file containing the keys and key identifiers used when operating
		# with symmetric key cryptography. 

	- restrict default kod nomodify notrap nopeer noquery
	
	- restrict、default定义默认访问规则，nomodify禁止远程主机修改本地服务器
	
	- restrict -6 default kod nomodify notrap nopeer noquery =====
配置，notrap拒绝特殊的ntpdq捕获消息，noquery拒绝btodq/ntpdc查询

	- restrict 127.0.0.1　（这里的查询是服务器本身状态的查询）。
	- restrict -6 ::1

	- restrict 192.168.20.0 mask 255.255.255.0 nomodify notrap　===== 这句是手动增加的，意思是指定的192.168.20.1--192.168.20.254的服务器都
可以使用ntp服务器来同步时间。

	- server 192.168.1.117　 ===== 手动添加，可以将局域网中的指定ip作为局域网内的ntp服务器。
	
			server 0.centos.pool.ntp.org
			server 1.centos.pool.ntp.org
			server 2.centos.pool.ntp.org　　　
	　　　　　　　　　　　　
	- 这3个域名都是互联网上的ntp服务器，也还有许多其他可用的ntp服务器，能连上外网时，本地会跟这几个ntp服务器上的时间保持同步。
	
			server 127.127.1.0 # local clock
			fudge 127.127.1.0 stratum 10　
			
	- 当服务器与公用的时间服务器失去联系时，就是连不上互联网时，以局域网内的时间服务器为客户端提供时间同步服务。

- 第三步，启动NTP服务：

	- /etc/init.d/ntpd start　　　当前启动ntpd服务
	
	- chkconfig ntpd on　　　下次开机自启ntpd服务

- 第四步，检查时间服务器是否正确同步

	- 在服务端执行 ntpq -p　 　

## 客户端的配置：

- 第一步，客户端安装NTP服务：

		yum install -y ntp
		
- 第二步，修改配置文件

		修改配置文件，添加上层时间服务器
		server   192.168.10.20   iburst
		
- 第二步，同步时间：

		ntpdate 服务器IP或者域名
		
		chkconfig ntpd on　　　下次开机自启ntpd服务