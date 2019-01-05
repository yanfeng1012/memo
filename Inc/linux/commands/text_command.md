1. find 文件查找

		查找txt和pdf文件:
		
		find . \( -name "*.txt" -o -name "*.pdf" \) -print
		正则方式查找.txt和pdf:
		
		find . -regex  ".*\(\.txt|\.pdf\)$"
		-iregex： 忽略大小写的正则
		
		否定参数 ,查找所有非txt文本:
		
		find . ! -name "*.txt" -print
		指定搜索深度,打印出当前目录的文件（深度为1）:
		
		find . -maxdepth 1 -type f
		定制搜索
		按类型搜索
		find . -type d -print  //只列出所有目录
		-type f 文件 / l 符号链接 / d 目录
		
		find支持的文件检索类型可以区分普通文件和符号链接、目录等，但是二进制文件和文本文件无法直接通过find的类型区分出来；
		
		file命令可以检查文件具体类型（二进制或文本）:
		
		$file redis-cli  # 二进制文件
		redis-cli: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.9, not stripped
		$file redis.pid  # 文本文件
		redis.pid: ASCII text
		所以,可以用以下命令组合来实现查找本地目录下的所有二进制文件:
		
		ls -lrt | awk '{print $9}'|xargs file|grep  ELF| awk '{print $1}'|tr -d ':'
		按时间搜索
		-atime 访问时间 (单位是天，分钟单位则是-amin，以下类似）
		-mtime 修改时间 （内容被修改）
		-ctime 变化时间 （元数据或权限变化）
		最近第7天被访问过的所有文件:
		
		find . -atime 7 -type f -print
		最近7天内被访问过的所有文件:
		
		find . -atime -7 -type f -print
		查询7天前被访问过的所有文件:
		
		find . -atime +7 type f -print
		按大小搜索：
		w字 k M G 寻找大于2k的文件:
		
		find . -type f -size +2k
		按权限查找:
		
		find . -type f -perm 644 -print //找具有可执行权限的所有文件
		按用户查找:
		
		find . -type f -user weber -print// 找用户weber所拥有的文件
		找到后的后续动作
		删除
		删除当前目录下所有的swp文件:
		
		find . -type f -name "*.swp" -delete
		另一种语法:
		
		find . type f -name "*.swp" | xargs rm
		执行动作（强大的exec）
		将当前目录下的所有权变更为weber:
		
		find . -type f -user root -exec chown weber {} \;
		注：{}是一个特殊的字符串，对于每一个匹配的文件，{}会被替换成相应的文件名；
		
		将找到的文件全都copy到另一个目录:
		
		find . -type f -mtime +10 -name "*.txt" -exec cp {} OLD \;
		结合多个命令
		如果需要后续执行多个命令，可以将多个命令写成一个脚本。然后 -exec 调用时执行脚本即可:
		
		-exec ./commands.sh {} \;
		-print的定界符
		默认使用’\n’作为文件的定界符；
		
		-print0 使用’\0’作为文件的定界符，这样就可以搜索包含空格的文件；
2. grep


		grep match_patten file // 默认访问匹配行
		常用参数
		
		-o 只输出匹配的文本行 VS -v 只输出没有匹配的文本行
		-c 统计文件中包含文本的次数
		grep -c “text” filename
		-n 打印匹配的行号
		-i 搜索时忽略大小写
		-l 只打印文件名
		在多级目录中对文本递归搜索(程序员搜代码的最爱）:
		
		grep "class" . -R -n
		匹配多个模式:
		
		grep -e "class" -e "vitural" file
		grep输出以0作为结尾符的文件名（-z）:
		
		grep "test" file* -lZ| xargs -0 rm
		综合应用：将日志中的所有带where条件的sql查找查找出来:
		
		cat LOG.* | tr a-z A-Z | grep "FROM " | grep "WHERE" > b
		查找中文示例：工程目录中utf-8格式和gb2312格式两种文件，要查找字的是中文；
		
		查找到它的utf-8编码和gb2312编码分别是E4B8ADE69687和D6D0CEC4
		
		查询:
		
		grep：grep -rnP "\xE4\xB8\xAD\xE6\x96\x87|\xD6\xD0\xCE\xC4" *即可
		汉字编码查询：http://bm.kdd.cc/

3. xargs

		xargs 能够将输入数据转化为特定命令的命令行参数；这样，可以配合很多命令来组合使用。比如grep，比如find； - 将多行输出转化为单行输出
		
		cat file.txt| xargs
		n 是多行文本间的定界符
		
		将单行转化为多行输出
		cat single.txt | xargs -n 3
		-n：指定每行显示的字段数
		
		xargs参数说明
		
		-d 定义定界符 （默认为空格 多行的定界符为 n）
		-n 指定输出为多行
		-I {} 指定替换字符串，这个字符串在xargs扩展时会被替换掉,用于待执行的命令需要多个参数时
		-0：指定0为输入定界符
		示例:
		
		cat file.txt | xargs -I {} ./command.sh -p {} -1
		
		#统计程序行数
		find source_dir/ -type f -name "*.cpp" -print0 |xargs -0 wc -l
		
		#redis通过string存储数据，通过set存储索引，需要通过索引来查询出所有的值：
		./redis-cli smembers $1  | awk '{print $1}'|xargs -I {} ./redis-cli get {}

4. sort

		字段说明
		
		-n 按数字进行排序 VS -d 按字典序进行排序
		-r 逆序排序
		-k N 指定按第N列排序
		示例:
		
		sort -nrk 1 data.txt
		sort -bd data // 忽略像空格之类的前导空白字符

5. tr转换 uniq 消除重复行

		unip消除重复行
		sort unsort.txt | uniq
		统计各行在文件中出现的次数
		sort unsort.txt | uniq -c
		找出重复行
		sort unsort.txt | uniq -d
		可指定每行中需要比较的重复内容：-s 开始位置 -w 比较字符数

		tr通用用法
-
		echo 12345 | tr '0-9' '9876543210' //加解密转换，替换对应字符
		cat text| tr '\t' ' '  //制表符转空格
		tr删除字符
		cat file | tr -d '0-9' // 删除所有数字
		-c 求补集
		
		cat file | tr -c '0-9' //获取文件中所有数字
		cat file | tr -d -c '0-9 \n'  //删除非数字数据
		tr压缩字符
		tr -s 压缩文本中出现的重复字符；最常用于压缩多余的空格:
		
		cat file | tr -s ' '
		字符类
		tr中可用各种字符类：
		alnum：字母和数字
		alpha：字母
		digit：数字
		space：空白字符
		lower：小写
		upper：大写
		cntrl：控制（非可打印）字符
		print：可打印字符
		使用方法：tr [:class:] [:class:]
		
		tr '[:lower:]' '[:upper:]'
6. cut按列切分文本

		取文件的第2列和第4列
		cut -f2,4 filename
		去文件除第3列的所有列
		cut -f3 --complement filename
		-d 指定定界符
		cat -f2 -d";" filename
		cut 取的范围
		N- 第N个字段到结尾
		-M 第1个字段为M
		N-M N到M个字段
		cut 取的单位
		-b 以字节为单位
		-c 以字符为单位
		-f 以字段为单位（使用定界符）
		示例:
		
		cut -c1-5 file //打印第一到5个字符
		cut -c-2 file  //打印前2个字符
		截取文本的第5到第7列
		
		$echo string | cut -c5-7
7. paste 按列拼接文本

		将两个文本按列拼接到一起;

		cat file1
		1
		2
		
		cat file2
		colin
		book
		
		paste file1 file2
		1 colin
		2 book
		默认的定界符是制表符，可以用-d指明定界符:
		
		paste file1 file2 -d ","
		1,colin
		2,book
8. wc 统计行和字符的工具

		$wc -l file // 统计行数

		$wc -w file // 统计单词数
		
		$wc -c file // 统计字符数
9. sed 

		首处替换
		sed 's/text/replace_text/' file   //替换每一行的第一处匹配的text
		全局替换
		sed 's/text/replace_text/g' file
		默认替换后，输出替换后的内容，如果需要直接替换原文件,使用-i:
		
		sed -i 's/text/repalce_text/g' file
		移除空白行
		sed '/^$/d' file
		变量转换
		已匹配的字符串通过标记&来引用.
		
		echo this is en example | sed 's/\w+/[&]/g'
		$>[this]  [is] [en] [example]
		子串匹配标记
		第一个匹配的括号内容使用标记 1 来引用
		
		sed 's/hello\([0-9]\)/\1/'
		双引号求值
		sed通常用单引号来引用；也可使用双引号，使用双引号后，双引号会对表达式求值:
		
		sed 's/$var/HLLOE/'
		当使用双引号时，我们可以在sed样式和替换字符串中指定变量；
		
		eg:
		p=patten
		r=replaced
		echo "line con a patten" | sed "s/$p/$r/g"
		$>line con a replaced
		其它示例
		字符串插入字符：将文本中每行内容（ABCDEF） 转换为 ABC/DEF:
		
		sed 's/^.\{3\}/&\//g' file
10. [awk](./awk.md)
11. 迭代

		1.迭代每一行
		while 循环法
		while read line;
		do
		echo $line;
		done < file.txt
		
		改成子shell:
		cat file.txt | (while read line;do echo $line;done)
		awk法
		cat file.txt| awk '{print}'
		2.迭代一行中的每一个单词
		for word in $line;
		do
		echo $word;
		done
		3. 迭代每一个字符
		${string:start_pos:num_of_chars}：从字符串中提取一个字符；(bash文本切片）
		
		${#word}:返回变量word的长度
		
		for((i=0;i<${#word};i++))
		do
		echo ${word:i:1);
		done
		以ASCII字符显示文件:
		
		$od -c filename

