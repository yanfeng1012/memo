## ImagePyramid 影像金字塔

### 用 FWTools 建立影像金字塔

- 下载并安装FWTools

		// 迅雷下载 网页下载已无法正常下载
		http://home.gdal.org/fwtools/FWTools247.exe
		
- 修复2.4.7版本bug

		安装完成后需要修改 bin 目录下的gdal_retile.py(Windows 版)，用编辑器打开bin/gdal_retile.py，把第273行修改成：
		
		print("Building internal Index for %d tile(s) ..." % len(inputTiles))
		
		去掉 print 方法的最后一个参数 end=' '，否则在 cmd 中执行命令会报错。
		
- 开启建立

		D:\FWTools2.4.7>D:\FWTools2.4.7\python\python.exe D:\FWTools2.4.7\bin\gdal_retile.py -v -r bilinear -levels 18 -ps 512 512 -co "TILED=YES" -co "COMPRESS=JPEG"   -targetDir F:\tiftest  F:\TiffData\result.tif
		
	- 参数说明

			levels 4  表示分成四级；

			ps 512 512  表示切片大小为512*512；

			COMPRESS=JPEG  表示按照jpeg方式压缩；

			targetDir F:\ tiftest   表示目标文件夹，即存放切片影像的文件夹；

			D:\TiffData\result.tif   表示待处理影像文件。
			
### geoserver 发布

- 下载 image pyramid [下载地址](http://geoserver.org/download/)

- 解压后将jar包放到`webapps\geoserver\WEB-INF\lib`中

- 选择image pyramid 发布

![image pyramid](/images/choice.png)

- 发布图层时，参数USE_JAI_IMAGEREAD设置为false
	