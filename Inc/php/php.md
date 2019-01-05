1. iconv  (字符串按要求的字符编码来转换)

		iconv ($in_charset ,$out_charset ,$str )
		eg:
			iconv('GBK',"UTF-8//TRANSLIT//IGNORE",$str)
	
		参数

		in_charset
		输入的字符集。
		
		out_charset
		输出的字符集。
		
		如果你在 out_charset 后添加了字符串 //TRANSLIT，将启用转写（transliteration）功能。
		这个意思是，当一个字符不能被目标字符集所表示时，它可以通过一个或多个形似的字符来近似表达。 
		如果你添加了字符串 //IGNORE，不能以目标字符集表达的字符将被默默丢弃。 
		否则，会导致一个 E_NOTICE并返回 FALSE。
		
		Caution
		//TRANSLIT 运行细节高度依赖于系统的 iconv() 实现。
		 据悉，某些系统上的实现会直接忽略 //TRANSLIT，所以转换也有可能失败，out_charset 会是不合格的。
		
		str
		要转换的字符串。
		
		返回值
		返回转换后的字符串， 或者在失败时返回 FALSE。

2. 查找字符出现的位置

		strpos     - 查找字符串首次出现的位置<br>
		stripos()  - 查找字符串在另一字符串中第一次出现的位置（不区分大小写）<br>
		strripos() - 查找字符串在另一字符串中最后一次出现的位置（不区分大小写）<br>
		strrpos()  - 查找字符串在另一字符串中最后一次出现的位置（区分大小写）<br>
		用法
		strpos(string,find,start)

3. php字符串驼峰转小写和下划线

		$tableName = strtolower(preg_replace('/(?<=[a-z])([A-Z])/', '_$1',$tableName))

4. php 接口（interface）

		interface usb{
		    const brand = 'siemens';    // 接口的属性必须是常量
		    public function connect();  // 接口的方法必须是public【默认public】，且不能有函数体
		}
		// new usb();  // 接口不能实例化
		
		// 类实现接口
		class Android implements usb{
		    public function connect(){  // 类必须实现接口的所有方法
		        echo '实现接口的connect方法';
		    }
		}
		
		
		interface usbA{
		    public function connect();
		}
		
		interface usbB{
		    public function contact();
		}
		
		// 类可以同时实现多个接口
		class mi implements usbA,usbB{
		    public function connect(){
		
		    }
		    public function contact(){
		
		    }
		}
		
5. [php 比较两个数组的差异](./php/array.md)
6. php 获取当前域名

		echo 'SERVER_NAME：'.$_SERVER['SERVER_NAME'];  //获取当前域名（不含端口号）
		echo '<p>';

		echo 'HTTP_HOST：'.$_SERVER['HTTP_HOST'];//获取当前域名  （含端口号）
		echo '<p>';

		echo 'REQUEST_URI：'.$_SERVER['REQUEST_URI'];//获取当前域名的后缀 
		
7. str_shuffle()

		str_shuffle() 函数随机打乱字符串中的所有字符。
		
8. unlink() 函数

		unlink() 函数删除文件。
		若成功，则返回 true，失败则返回 false。
		
		unlink(filename,context)
		
		filename	必需。规定要删除的文件。
		context	可选。规定文件句柄的环境。Context 是可修改流的行为的一套选项。
		
9. emepty()

	empty(0) or empty(null) === true 