- strconv 包
	`strconv包提供了字符串与简单数据类型之间的类型转换功能。可以将简单类型转换为字符串，也可以将字符串转换为其它简单类型。`
	- 字符串转int：`Atoi()`
	- int转字符串: `Itoa()`
	- ParseTP类函数将string转换为TP类型：`ParseBool()`、`ParseFloat()`、`ParseInt()`、`ParseUint()`。因为string转其它类型可能会失败，所以这些函数都有第二个返回值表示是否转换成功
	- FormatTP类函数将其它类型转string：`FormatBool()`、`FormatFloat()`、`FormatInt()`、`FormatUint()`
	- AppendTP类函数用于将TP转换成字符串后append到一个slice中：`AppendBool()`、`AppendFloat()`、`AppendInt()`、`AppendUint()`

	- [参考](https://www.cnblogs.com/f-ck-need-u/p/9863915.html)

- [golang import 导入包语法介绍](https://blog.csdn.net/whatday/article/details/98046785)

	- 点操作

	有时候会看到如下的方式导入包：

		import( 
		    . "fmt" 
		) 
		
	这个点操作的含义就是这个包导入之后在你调用这个包的函数时，你可以省略前缀的包名，也就是前面你调用的：

		fmt.Println( "我爱公园" )
		
	可以省略的写成：

		Println( "我爱公园" )
		
	- 别名操作

	别名操作顾名思义可以把包命名成另一个用起来容易记忆的名字：
		
		import( 
		    f "fmt" 
		) 
		
	别名操作调用包函数时前缀变成了重命名的前缀，即：

     	f.Println( "我爱北京天安门" )
	
	- 下划线操作

	这个操作经常是让很多人费解的一个操作符，请看下面这个 import

		import ( 
		    “database/sql” 
		    _ “github.com/ziutek/mymysql/godrv” 
		) 
		
	下滑线 `“_”` 操作其实只是引入该包。当导入一个包时，它所有的 init() 函数就会被执行，但有些时候并非真的需要使用这些包，仅仅是希望它的 init() 函数被执行而已。这个时候就可以使用 `“_”` 操作引用该包了。即使用 `“_”` 操作引用包是无法通过包名来调用包中的导出函数，而是只是为了简单的调用其 init() 函数。