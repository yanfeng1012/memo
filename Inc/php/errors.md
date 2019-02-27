- [] operator not supported for string


		在使用类似下面的方法进行数据赋值时可能出现这样的错误：
		
		$test_arr[] = $t;
		
		而且是在当前页面对$test_arr进行第二次赋值的时候，也就是在同一页面内对同一变量第二次赋值，但值的类型不一致会导致这个错误