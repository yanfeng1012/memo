## CentOS Local yum repo

- 挂载镜像文件或者手动添加<br>

	在/root下创建rpm目录，可以在此下载对应rpm包，[https://mirrors.aliyun.com/centos/6.9/os/x86_64/Packages/](https://mirrors.aliyun.com/centos/6.9/os/x86_64/Packages/)

	   	/root/rpm/
		----- Packages/ 存放rpm包
		----- repodata/ rpm包的索引目录
  	
- 备份其他的repo

		  # cd /etc/yum.repos.d/
		  # mv CentOS-Base.repo CentOS-Base.repo_bak
		  # mv CentOS-Debuginfo.repo CentOS-Debuginfo.repo_bak
  
- 创建本地repo

		  # vim CentOS-Local.repo
		  [CentOS-Local] # 不能有空格
		  baseurl=file:///root/rpm/   # 挂载目录或者rpm包目录
		  gpgcheck=0 # 是否校验签名，0不校验，1校验
		  enabled=1 # 是否开启
		  
- 清除缓存

		  yum clean all
		  yum list 
		  
## CentOS7配置阿里云yum源和EPEL源

- 配置阿里云yum源(参考：[http://mirrors.aliyun.com/help/centos](http://mirrors.aliyun.com/help/centos))

- 备份

		[root@bogon ~]# cd /etc/yum.repos.d/
		[root@bogon yum.repos.d]# mkdir repo_bak
		[root@bogon yum.repos.d]# mv *.repo repo_bak/
		[root@bogon yum.repos.d]# ls
		repo_bak
		
- 下载新的CentOS-Base.repo 到/etc/yum.repos.d/

		[root@bogon yum.repos.d]# wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
		--2018-02-09 16:33:46--  http://mirrors.aliyun.com/repo/Centos-7.repo
		Resolving mirrors.aliyun.com (mirrors.aliyun.com)... 124.14.2.234, 124.14.2.235, 124.14.2.217, ...
		Connecting to mirrors.aliyun.com (mirrors.aliyun.com)|124.14.2.234|:80... connected.
		HTTP request sent, awaiting response... 200 OK
		Length: 2573 (2.5K) [application/octet-stream]
		Saving to: ‘/etc/yum.repos.d/CentOS-Base.repo’
		
		100%[========================================================================================>] 2,573       --.-K/s   in 0s      
		
		2018-02-09 16:33:47 (182 MB/s) - ‘/etc/yum.repos.d/CentOS-Base.repo’ saved [2573/2573]
		
		[root@bogon yum.repos.d]# ls
		CentOS-Base.repo  repo_bak	