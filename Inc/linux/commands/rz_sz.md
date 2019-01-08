## linux 使用 rz 和 sz 命令

1. 安装

- 编译安装

		root 账号登陆后，依次执行以下命令：
		tar zxvf lrzsz-0.12.20.tar.gz
		cd lrzsz-0.12.20
		./configure
		make
		make install
		上面安装过程默认把lsz和lrz安装到了/usr/local/bin/目录下，现在我们并不能直接使用，下面创建软链接，并命名为rz/sz：
		cd /usr/bin
		ln -s /usr/local/bin/lrz rz
		ln -s /usr/local/bin/lsz sz
		
2. 使用说明

- sz命令发送文件到本地：

		sz filename

- rz命令本地上传文件到服务器：

		rz
		执行该命令后，在弹出框中选择要上传的文件即可。
		说明：打开SecureCRT软件 -> Options -> session options -> X/Y/Zmodem 下可以设置上传和下载的目录。
		
## mac使用 rz 和 sz 命令


- 在Mac上安装 rz && sz (lrzsz[下载安装包lrzsz-0.12.20.tar.gz]( http://www.ohse.de/uwe/software/lrzsz.html))

	- 解压下载的lrzsz文件：`tar -xvf lrzsz-0.12.20.tar.gz`
	- 进入解压后的文件夹：`cd lrzsz-0.12.20`
	- 准备编译：`./configure`
	- 编译安装：`make && make install`
	- 建立连接：`ln -s /usr/local/bin/lsz /usr/local/bin/sz`<br/>
     			`ln -s /usr/local/bin/lrz /usr/local/bin/rz`

- 在[https://github.com/mmastrac/iterm2-zmodem](https://github.com/mmastrac/iterm2-zmodem)下载iterm2-recv-zmodem.sh和iterm2-send-zmodem.sh文件，放入/usr/local/bin目录。

- 打开iTerm2后，按组合键command和，打开iTerm2设置界面，如图所示，点"Edit"；

![图片1](/images/mac_rz_sz_1.png)

- 点击+号,添加如下的参数,参考下图

![图片2](/images/mac_rz_sz_2.jpg)

            Regular expression: /*/*B0100
	
	    Action: Run Silent Coprocess
	
	    Parameters:/usr/local/bin/iterm2-send-zmodem.sh
	
	    Regular expression: /*/*B00000000000000
	
	    Action: Run Silent Coprocess
	
	    Parameters:/usr/local/bin/iterm2-recv-zmodem.sh
