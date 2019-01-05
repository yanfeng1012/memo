## uploadifive

- 引入插件

		<link rel="stylesheet" href="{{ asset('public/uploadifive/uploadifive.css') }}">
		<script src="{{ asset('public/uploadifive/jquery.uploadifive.js') }}"></script>

- DOM结构

		<input id="file_upload" type="file"/> （id非常重要）

- javascript

		<script>
			$("#file_upload").uploadifive({
				'uploadScript':'{{ path('paymentrecord_upload') }}',
		        'buttonText':'上传图片',
		        'multi':false,
				'fileObjName' : 'file', （***上传文件name值***）
		        'onUploadComplete' :function(file,data){
		           	var data = JSON.parse(data);
		           	if(data.state == "SUCCESS"){
						$('.bank_attachment').val(data.url);
						$('.image-perview img').attr('src',data.url);
						layui.layer.msg('上传成功');
		           	}else if(data.state == "FAILD"){
						layui.layer.msg('上传方式不合法');
		           	}else{
		           		layui.layer.msg('图片不能为空');
		           	}
		      	}
			});
		</script>

		/* 相关属性和方法 */

		1.属性	             作用
		auto	             是否自动上传，默认true
		uploadScript	     上传路径
		fileObjName	file     文件对象名称
		buttonText	         上传按钮显示文本
		queueID	             进度条的显示位置
		fileType	         上传文件类型
		multi	             是否允许多个文件上传，默认为true
		fileSizeLimit	     允许文件上传的最大尺寸
		uploadLimit	         一次可以上传的最大文件数
		queueSizeLimit	    允许队列中存在的最大文件数
		removeCompleted	    隐藏完成上传的文件，默认为false

		2.方法	            作用
		onUploadComplete	文件上传成功后执行
		onCancel	        文件被删除时触发
		onUpload	        开始上传队列时触发
		onFallback	        HTML5 API不支持的浏览器触发

- 服务端

  - 详见	[uploadifive](/Inc/symfony/UploadFile.md)

![相关属性和方法](/images/uploadifive.png)