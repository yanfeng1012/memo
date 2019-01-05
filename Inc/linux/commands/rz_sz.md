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