## awk

		awk脚本结构
		awk ' BEGIN{ statements } statements2 END{ statements } '
		工作方式
		1.执行begin中语句块；
		
		2.从文件或stdin中读入一行，然后执行statements2，重复这个过程，直到文件全部被读取完毕；
		
		3.执行end语句块；
		
		print 打印当前行
		使用不带参数的print时，会打印当前行
		echo -e "line1\nline2" | awk 'BEGIN{print "start"} {print } END{ print "End" }'
		print 以逗号分割时，参数以空格定界;
		echo | awk ' {var1 = "v1" ; var2 = "V2"; var3="v3"; \
		print var1, var2 , var3; }'
		$>v1 V2 v3
		使用-拼接符的方式（”“作为拼接符）;
		echo | awk ' {var1 = "v1" ; var2 = "V2"; var3="v3"; \
		print var1"-"var2"-"var3; }'
		$>v1-V2-v3
		特殊变量： NR NF $0 $1 $2
		NR:表示记录数量，在执行过程中对应当前行号；
		
		NF:表示字段数量，在执行过程总对应当前行的字段数；
		
		$0:这个变量包含执行过程中当前行的文本内容；
		
		$1:第一个字段的文本内容；
		
		$2:第二个字段的文本内容；
		
		echo -e "line1 f2 f3\n line2 \n line 3" | awk '{print NR":"$0"-"$1"-"$2}'
		打印每一行的第二和第三个字段
		awk '{print $2, $3}' file
		统计文件的行数
		awk ' END {print NR}' file
		累加每一行的第一个字段
		echo -e "1\n 2\n 3\n 4\n" | awk 'BEGIN{num = 0 ;
		print "begin";} {sum += $1;} END {print "=="; print sum }'
		传递外部变量
		var=1000
		echo | awk '{print vara}' vara=$var #  输入来自stdin
		awk '{print vara}' vara=$var file # 输入来自文件
		用样式对awk处理的行进行过滤
		awk 'NR < 5' #行号小于5
		awk 'NR==1,NR==4 {print}' file #行号等于1和4的打印出来
		awk '/linux/' #包含linux文本的行（可以用正则表达式来指定，超级强大）
		awk '!/linux/' #不包含linux文本的行
		设置定界符
		使用-F来设置定界符（默认为空格）:
		
		awk -F: '{print $NF}' /etc/passwd
		读取命令输出
		使用getline，将外部shell命令的输出读入到变量cmdout中:
		
		echo | awk '{"grep root /etc/passwd" | getline cmdout; print cmdout }'
		在awk中使用循环
		for(i=0;i<10;i++){print $i;}
		for(i in array){print array[i];}
		eg:以下字符串，打印出其中的时间串:
		
		2015_04_02 20:20:08: mysqli connect failed, please check connect info
		$echo '2015_04_02 20:20:08: mysqli connect failed, please check connect info'|awk -F ":" '{ for(i=1;i<=;i++) printf("%s:",$i)}'
		>2015_04_02 20:20:08:  # 这种方式会将最后一个冒号打印出来
		$echo '2015_04_02 20:20:08: mysqli connect failed, please check connect info'|awk -F':' '{print $1 ":" $2 ":" $3; }'
		>2015_04_02 20:20:08   # 这种方式满足需求
		而如果需要将后面的部分也打印出来(时间部分和后文分开打印):
		
		$echo '2015_04_02 20:20:08: mysqli connect failed, please check connect info'|awk -F':' '{print $1 ":" $2 ":" $3; print $4;}'
		>2015_04_02 20:20:08
		>mysqli connect failed, please check connect info
		以逆序的形式打印行：(tac命令的实现）:
		
		seq 9| \
		awk '{lifo[NR] = $0; lno=NR} \
		END{ for(;lno>-1;lno--){print lifo[lno];}
		} '
		awk结合grep找到指定的服务，然后将其kill掉
		ps -fe| grep msv8 | grep -v MFORWARD | awk '{print $2}' | xargs kill -9;
		awk实现head、tail命令
		head
		awk 'NR<=10{print}' filename
		tail
		awk '{buffer[NR%10] = $0;} END{for(i=0;i<11;i++){ \
		print buffer[i %10]} } ' filename
		打印指定列
		awk方式实现
		ls -lrt | awk '{print $6}'
		cut方式实现
		ls -lrt | cut -f6
		打印指定文本区域
		确定行号
		seq 100| awk 'NR==4,NR==6{print}'
		确定文本
		打印处于start_pattern 和end_pattern之间的文本:
		
		awk '/start_pattern/, /end_pattern/' filename
		示例:
		
		seq 100 | awk '/13/,/15/'
		cat /etc/passwd| awk '/mai.*mail/,/news.*news/'
		awk常用内建函数
		index(string,search_string):返回search_string在string中出现的位置
		
		sub(regex,replacement_str,string):将正则匹配到的第一处内容替换为replacement_str;
		
		match(regex,string):检查正则表达式是否能够匹配字符串；
		
		length(string)：返回字符串长度
		
		echo | awk '{"grep root /etc/passwd" | getline cmdout; print length(cmdout) }'
		printf 类似c语言中的printf，对输出进行格式化:
		
		seq 10 | awk '{printf "->%4s\n", $1}'