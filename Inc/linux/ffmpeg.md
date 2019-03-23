## linux安装FFmpeg

- 安装yasm

		# cd ~
		# wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
		# tar zxvf yasm-1.3.0.tar.gz
		# cd yasm-1.3.0
		# ./configure
		# make && make install
		
- 安装lame

		# cd ~
		# wget https://sourceforge.net/projects/lame/files/lame/3.100/lame-3.100.tar.gz		
		# tar -zxf lame-3.100.tar.gz
		# cd lame-3.100
		# ./configure
		# make && make install
		
- **安装FFmpeg**


		# cd ~
		# wget http://ffmpeg.org/releases/ffmpeg-4.1.1.tar.bz2
		# tar zxvf ffmpeg-4.1.2.tar.bz2
		# cd ffmpeg-4.1.1
		# ./configure --prefix=/usr --enable-libmp3lame
		# make && make install
		
	- **CentOS安装ffmpeg并支持编码mp3的坑**
		- error
		
				ffmpeg: error while loading shared libraries: libmp3lame.so.0: cannot open shared object file: No such file or directory
				
		- reason 

			>ffmpeg默认安装目录为/usr/local/lib，有些64位系统下软件目录则为/usr/lib64，编译过程中可能会出现ffmpeg: error while loading shared libraries: libmp3lame.so.0: cannot open shared object file: No such file or directory等类似的错误，解决办法是建立软链接或者移动库文件到相应的目录：		
		- fix

				ln -s /usr/local/lib/libmp3lame.so.0.0.0 /usr/lib64/libmp3lame.so.0
				mv /usr/local/lib/libmp3lame.so.0.0.0 /usr/lib64/libmp3lame.so.0