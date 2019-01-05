- 序列化提交表单

		$(".add_text").on('click',function(){
			$.ajax({
				type:'post',
				url:"{{ path('personnel_newstaff_new') }}",
				data:{
					data:$(this).parents("form").serializeArray()
				},
				dataType:'json',
				success:function(result){
					if(result.code == 1){
						layer.alert(result.msg,{icon:1});
					}else{
						layer.alert(result.msg,{icon:2});
					}
				}
			})
		})
