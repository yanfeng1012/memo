## freeXserver 

### docker

#### 安装

> 安装docker前需确认当前Linux内核版本为3.10以上

- 安装存储库

		yum install -y yum-utils device-mapper-persistent-data lvm2 
		
- 设置稳定的存储库

		yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
		
		如果上述链接下载不了，则可使用如下链接
		yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
	   
- 查看仓库中的docker版本

   		yum list docker-ce --showduplicates | sort -r
   		
- 下载最新版本docker

   		yum install docker-ce docker-ce-cli containerd.io
   		
- 查看当前的docker的版本

   		docker --version
   		docker version  查看版本以及服务和客户端的版本

#### 启动
	
	systemctl start docker
	
#### 设置开机自启

	systemctl enable docker 
	
### 部署freexserver

#### 基础环境

- 创建网桥

   		docker network create -d bridge --subnet 172.25.0.0/16 isolated_nw
   
- 导入和启动postgresql：

   		导入：
   		cat postgresql.tar |docker import - postgresql 
   		
   		启动：
   		docker run --name "postgresql" --network=isolated_nw --ip=172.25.3.1 -p 5436:5432 -d -t postgresql /bin/sh -c /docker-entrypoint.sh
   		
- 导入redis镜像和启动redis

   		导入：
   		docker load < redis.tar
   		
   		启动：
   		docker run -d -p 6379:6379 --network=isolated_nw --ip=172.25.3.2 --name myredis redis:5.0
   
- 导入和启动mongo

   		导入：
   		docker load < mongo.tar
   		
   		启动：
   		docker run -d -p 27017:27017 --network=isolated_nw --ip=172.25.3.3 --name mymongo mongo:4.2.1   
   
- 导入和启动mapserver服务

    	导入：
    	docker load < mapserver.tar  
    	
		启动：
		docker run -d -p 8088:8080 -v /home/ly/data:/usr/dataserver --network=isolated_nw --ip=172.25.3.4 --name mapserver mapserver:1.2.2  
		
	**(其中`/home/ly/data`为挂载在该容器下的宿主机目录，因此发布服务的数据，可以放在这个目录下)**
	
- 导入和启动tilemapserver服务

   		导入：docker load < tileserver.tar
   		启动：docker run -d -p 8091:8091 --network=isolated_nw --ip=172.25.3.5 --name tileserver tileserver:1.2.1
  
- 开放8088端口

		firewall-cmd --zone=public --add-port=8088/tcp --permanent
    	firewall-cmd --reload
    	
#### 服务应用

- 启动docker下服务
	- 查看容器ID号
	
			docker ps -a
			
	- 启动容器（**启动顺序非常重要** 先启动mymongo、myredis、postgresql;再启动tileserver、mapserver）

			docker start [容器ID|容器名]
			
- mapserver部署
	- 进入容器
	 
			docker exec -it [容器ID] /bin/bash
			
	- 解压文件（online文件和onlineData文件）

			cd /usr/local/soft/
			unzip -O GBK v2.0.0.zip
			cd /usr/local/soft/onlineData/
			unzip -O GBK cityData.zip
			unzip -O GBK terrain.zip
	
	- 更改文件配置项
	
			sed -i "s/www.freexgis.com/192.168.1.251:8088/g" /usr/local/soft/v2.0.0/static/js/config.js
			sed -i "s/www.freexgis.com/192.168.1.251:8088/g" /usr/local/soft/v2.0.0/static/json/config.json
			sed -i "s/www.freexgis.com/192.168.1.251:8088/g" usr/local/soft/v2.0.0/static/json/config2d/layerConfig.json

			将以上三个文件中的www.freexgis.com字段修改为mapserver服务地址（宿主机本地的ip+端口）
			
	- 登录FreeXserver和online

			http://192.168.1.251:8088/freexserver
			http://192.168.1.251:8088/online
	

	
		
    
