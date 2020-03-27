1. [安装PHP7.3.6](./php/install7.3.6.md)
2. `iconv`  (字符串按要求的字符编码来转换)

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

3. 查找字符出现的位置

		strpos     - 查找字符串首次出现的位置<br>
		stripos()  - 查找字符串在另一字符串中第一次出现的位置（不区分大小写）<br>
		strripos() - 查找字符串在另一字符串中最后一次出现的位置（不区分大小写）<br>
		strrpos()  - 查找字符串在另一字符串中最后一次出现的位置（区分大小写）<br>
		用法
		strpos(string,find,start)

4. php字符串驼峰转小写和下划线

		$tableName = strtolower(preg_replace('/(?<=[a-z])([A-Z])/', '_$1',$tableName))

5. php 接口（interface）

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
		
6. [php 比较两个数组的差异](./php/array.md)
7. php 获取当前域名

		echo 'SERVER_NAME：'.$_SERVER['SERVER_NAME'];  //获取当前域名（不含端口号）
		echo '<p>';

		echo 'HTTP_HOST：'.$_SERVER['HTTP_HOST'];//获取当前域名  （含端口号）
		echo '<p>';

		echo 'REQUEST_URI：'.$_SERVER['REQUEST_URI'];//获取当前域名的后缀 
		
8. `str_shuffle()`

		str_shuffle() 函数随机打乱字符串中的所有字符。
		
9. `unlink()` 函数

		unlink() 函数删除文件。
		若成功，则返回 true，失败则返回 false。
		
		unlink(filename,context)
		
		filename	必需。规定要删除的文件。
		context	可选。规定文件句柄的环境。Context 是可修改流的行为的一套选项。
		
10. `emepty()`

		empty(0) or empty(null) === true 
	
11. `strlen() && mb_strlen()`

		函数返回字符串的长度

12. `extract()`

	- 将键值 "Cat"、"Dog" 和 "Horse" 赋值给变量 $a、$b 和 $c：
	
			<?php
				$a = "Original";
				$my_array = array("a" => "Cat","b" => "Dog", "c" => "Horse");
				extract($my_array);
				echo "\$a = $a; \$b = $b; \$c = $c";
			?>
			
	- extract() 函数从数组中将变量导入到当前的符号表。
	
		`extract(array,extract_rules,prefix)`
	
		1. 该函数使用数组键名作为变量名，使用数组键值作为变量值。针对数组中的每个元素，将在当前符号表中创建对应的一个变量。
		
		2. 第二个参数 type 用于指定当某个变量已经存在，而数组中又有同名元素时，extract() 函数如何对待这样的冲突。
	
				EXTR_OVERWRITE - 默认。如果有冲突，则覆盖已有的变量。
				EXTR_SKIP - 如果有冲突，不覆盖已有的变量。
				EXTR_PREFIX_SAME - 如果有冲突，在变量名前加上前缀 prefix。
				EXTR_PREFIX_ALL - 给所有变量名加上前缀 prefix。
				EXTR_PREFIX_INVALID - 仅在不合法或数字变量名前加上前缀 prefix。
				EXTR_IF_EXISTS - 仅在当前符号表中已有同名变量时，覆盖它们的值。其它的都不处理。
				EXTR_PREFIX_IF_EXISTS - 仅在当前符号表中已有同名变量时，建立附加了前缀的变量名，其它的都不处理。
				EXTR_REFS - 将变量作为引用提取。导入的变量仍然引用了数组参数的值。
		
		3. 该函数返回成功导入到符号表中的变量数目。
	
13. 压缩 解压缩函数

		压缩函数：gzcompress gzdeflate gzencode
		
		解压函数：gzuncompress gzinflate gzdecode
		
		gzcompress使用的是ZLIB格式；
		
		gzdeflate使用的是纯粹的DEFLATE格式；
		
		gzencode使用的是GZIP格式；
		
14. `eregi()`

	>`eregi()`函数在一个字符串搜索指定的模式的字符串。搜索不区分大小写。`Eregi()`可以特别有用的检查有效性字符串,如密码。
	
	>返回值
	>如果匹配成功返回true,否则,则返回false

	>eg.eregi ("/\w{8,10}/", $password)
	
15. `strcmp()`比较字符串

		int strcmp ( string $str1 , string $str2 )
		// 参数 str1第一个字符串。str2第二个字符串。如果 str1 小于 str2 返回 < 0； 如果 str1 大于 str2 返回 > 0；如果两者相等，返回 0。

16. `intval()`

		intval() 获取变量的整数值
	
17. `dechex()`

		dechex() 函数把十进制转换为十六进制。
		
18. `escapeshellarg()` 

		 把字符串转码为可以在 shell 命令里使用的参数
		 eg: system('ls '.escapeshellarg($dir));

19. `current()`

		输出数组中的当前元素(指针)的值
		eg: $people = array("Peter", "Joe", "Glenn", "Cleveland");
		echo current($people) . "<br>";

20. `compact()`

		创建一个包含变量名和它们的值的数组：
		eg: $firstname = "Peter";
			 $lastname = "Griffin";
			 $age = "41";
			 $result = compact("firstname", "lastname", "age");
			 
21. [PHP可变参数](https://blog.csdn.net/weixin_34303897/article/details/88036724)

22. `str_pad()`

		函数把字符串填充为新的长度
		
		str_pad(string,length,pad_string,pad_type)
		string	      必需。规定要填充的字符串。
		length	      必需。规定新字符串的长度。如果该值小于原始字符串的长度，则不进行任何操作。
		pad_string  可选。规定供填充使用的字符串。默认是空白。
		pad_type	  可选。规定填充字符串的哪边。
		
		可能的值：
		STR_PAD_BOTH - 填充字符串的两侧。如果不是偶数，则右侧获得额外的填充。
		STR_PAD_LEFT - 填充字符串的左侧。
		STR_PAD_RIGHT - 填充字符串的右侧。这是默认的。
		
		eg: $str = "Hello World";
		    echo str_pad($str,20,".");

23. `array_count_values()`

		统计数组中所有值出现的次数：
		array_count_values(array)
		
		参数  : 	array 必需。规定需要统计数组中所有值出现次数的数组。
		返回值:   返回一个关联数组，其元素的键名是原数组的值，键值是该值在原数组中出现的次数。