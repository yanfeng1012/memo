- 在父层获取子层ifram窗口对象并执行窗口对象的方法

		var iframeWin = window[layero.find('iframe')[0]['name']]; //得到iframe页的窗口对象，
		iframeWin.onPageClose(); //执行iframe页的方法：iframeWin.method()

- 在子层执行父层方法

		var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
		parent.layer.close(index); //再执行关闭

		ps: parent父层对象
