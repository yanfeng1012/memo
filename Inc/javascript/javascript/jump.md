- js 跳转

	1. 跳转链接 在当前窗口打开
	
			window.location.href="http://www.baidu.com"   等价于    <a href="baidu.com" target="_self">go baidu</a>  
		
	2. 跳转链接 在新窗口打开
	
			window.open("http://www.baidu.com")  等价于 <a href="baidu.com" target="_blank">go baidu</a>
	
	3. 跳转链接 返回上一页
	
			window.history.back(-1);
	
	4. 跳转链接
	
			self.location.href="baidu.com"
	
	5. ps:
	
			self 指代当前窗口对象，属于window 最上层的对象。

    			location.href 指的是某window对象的url的地址

			self.location.href 指当前窗口的url地址，去掉self默认为当前窗口的url地址，一般用于防止外部的引用

			top.location.href:为引用test.html页面url的父窗口对象的url

			如果你的网页地址是:http://www.a.com，别人的是http://www.b.com, 他在他的页面用iframe等框架引用你的http://www.a.com,那么你可以用:

			if(top.location.href!=self.location.href){
			       location.href="http://www.a.com";
			}

			来转向你的页面,top指代的是主体窗口,这里top.location.href返回http://www.b.com;

			http://www.b.com!=http://www.a.com,返回为真(true),则网页重定向到你的网页,做到防盗用的作用.