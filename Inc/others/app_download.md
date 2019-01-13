## APP端 apk or IPA 下载js判断

- view层js

		<script src="{{ asset('js/jquery-1.8.3.min.js'|theme) }}"></script>
		<script type="text/javascript">
	        $(function () {
	        	var u = navigator.userAgent, app = navigator.appVersion;
	            var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Linux') > -1; //安卓客服端
	            var isIOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端
	            if (isAndroid) { //安卓遮罩层
	            	if(checkWeixin()){
	            		$('#android_mask').css('display','block');
	                	$('#ios_mask').css('display','none');
	            	}else{
	            		$('#android_mask').css('display','none');
	                	$('#ios_mask').css('display','none');
	            	}
	            	$('.download_edition').html('版本号:  V'+"{{ versionnum['android'] }}");
	            	$('#download').attr('onclick','check("{{ uri['android'] }}");');
	            }
	            if (isIOS) { //iOS遮罩层
	            	if(checkWeixin()){
	            		$('#android_mask').css('display','none');
	                	$('#ios_mask').css('display','block');
	            	}else{
	            		$('#android_mask').css('display','none');
	                	$('#ios_mask').css('display','none');
	            	}
	            	$('.download_edition').html('版本号:  V'+"{{ versionnum['ios']|default('1.0.0') }}");
	            	$('#download').attr('onclick','check("{{ uri['ios'] }}");');
	            }
	        });
	        function checkWeixin(){ //检查是否是微信浏览器
	        	var ua = window.navigator.userAgent.toLowerCase();
	            if (ua.match(/MicroMessenger/i) == 'micromessenger') {//微信浏览器
					return true;
	            }else{
	           	 	return false;
	            }
	        }
	
	        function check(file){ //APP下载前检查文件手否存在
				$.post('{{ path('check') }}',{file:file},
					function(result){
						if(result.code != 1){
							alert(result.msg);
							return false;
						}else{
							window.location.href = result.data;
						}
					}
				)
	        }
		</script>

		
	
