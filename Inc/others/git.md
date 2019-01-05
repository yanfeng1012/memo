## 解决eclipse中egit中的cannot open git-upload-pack问题

>我们在eclipse上使用插件egit向github或者bitbucket同步代码时，有时候会发现出现cannot open git-upload-pack这个问题。

- 一般引起这个问题的原因有两个：
 - 一、网络问题，天朝的网络访问外网总是会出现各种不稳定因素，你懂的。
 - 二、eclipse中egit插件的配置问题。

### 解决方法
 
	1.打开eclipse中的
	windows-->Preferences-->Team-->Git-->Configuration-->User Settings.
	然后点Add Entry新建一个键值对，输入http.sslVerify=false。
	2.所有的前提是你能用浏览器访问https://github.com/或者https://bitbucket.org/
	3.仔细检查自己的username和email是否正确
