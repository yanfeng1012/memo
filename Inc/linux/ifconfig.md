## linux 网卡配置文件详解

>`配置文件位置：/etc/sysconfig/network-scripts/ifcfg-eth0`

1. DEVICE=eth0 `网卡的名字`

2. HWADDR=00:0c:29:90:89:d9 HWADDR HardWare Address `硬件地址 MAC地址`

3. TYPE=Ethernet `网络类型 以太网`

4. UUID=ae779ae6-044d-43d5-a33b-48c89e8de10e #UUID 做到系统中独一无二。

5. ONBOOT=yes BOOT ON ? `在开机或重启网卡的时候是否启动网卡`

6. NM_CONTROLLED=yes `是否受network程序管理`

7. BOOTPROTO=none 网卡是如何获取到ip地址 `网卡获取ip地址的方式`

		a. dhcp 自动获取ip地址
		b. none 固定的ip地址
		c. static 固定的ip地址

8. IPADDR=10.0.0.100 IPADDR `ip地址`

9. NETMASK=255.255.255.0 `子网掩码` 决定这个局域网中最多有多少台机器

10. GATEWAY=10.0.0.2 `网关` 整个大楼的大门

11. USERCTL=no `普通用户是否能控制网卡`

12. /etc/resolv.conf `配置DNS 网卡配置文件的DNS优先于/etc/resolv.conf`

13. DNS 域名解析器 阿里的域名解析器：223.5.5.5 223.6.6.6


	- `重启网卡` service network restart(centos 6) || systemctl restart network(centos 7)
	
14. DNS配置文件：`cat /etc/resolv.conf`
    设置主机和IP绑定信息：`cat /etc/hosts`
    设置主机名：`cat /etc/hostname`
    
15. 关闭防火墙并设置开机不启动

		查看防火墙状态：systemctl status firewalld.service
		关闭：systemctl stop firewalld
		开启：systemctl start firewalld
		开机自动关闭：systemctl disable firewalld
		开机自动启动：systemctl enable firewalld
		查看开机是否启动：chkconfig --list|grep network(RHLE6)
