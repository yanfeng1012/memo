## geoserver

#### 安装部署

- 安装Java

1. 查看是否有Java环境

		rpm -qa | grep java
		
2. 安装Java环境

		yum -y install java-1.8.0-openjdk*
		
3. 检验Java是否安装成功	

		java -version
		
- 安装geoserver

1. 下载

		wget https://codeload.github.com/geoserver/geoserver/tar.gz/2.17.2
		
2. 解压

		tar -zxvf geoserver-2.17.2.tar.gz
		
3. 修改端口

		cd 	geoserver-2.17.2
		vim start.ini
		//修改端口
		jetty.port=8003
		
4. 启动程序

		cd bin
		./startup.sh
		
- 设置GEOSERVER_HOME	

> 不设置`GEOSERVER_HOME`，只能进入到geoserver的根目录下执行startup.sh；设置`GEOSERVER_HOME`以后，就可以在任何目录来启动geoserver

1. 编辑

		vim /etc/profile 
2. 增加

		export GEOSERVER_HOME=/opt/geoserver-2.17.2
 
3. 引入生效

		source /etc/profile
		
#### 配置imagePyramid

- 下载安装

		在Geoserver官网上下载对应版本的ImagePyramid。
		解压后将jar包放到webapps\geoserver\WEB-INF\lib中