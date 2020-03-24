## FIND_IN_SET(str,strlist)

1. 语法

		FIND_IN_SET(str,strlist)
	
	- str 要查询的字符串
	- strlist 字段名 参数以”,”分隔 如 (1,2,6,8)
	- 查询字段(strlist)中包含(str)的结果，返回结果为null或记录

		1. 假如字符串str在由N个子链组成的字符串列表strlist 中，则返回值的范围在 1 到 N 之间。 
		2. 一个字符串列表就是一个由一些被 ‘,’ 符号分开的子链组成的字符串。
		3. 如果第一个参数是一个常数字符串，而第二个是type SET列，则FIND_IN_SET() 函数被优化，使用比特计算。
		4. 如果str不在strlist 或strlist 为空字符串，则返回值为 0 。
		5. 如任意一个参数为NULL，则返回值为 NULL。这个函数在第一个参数包含一个逗号(‘,’)时将无法正常运行。

2. 例子

		mysql> SELECT FIND_IN_SET('b', 'a,b,c,d'); 
		-> 2 
		因为b 在strlist集合中放在2的位置 从1开始

		select FIND_IN_SET('1', '1'); 返回 就是1 
		这时候的strlist集合有点特殊 只有一个字符串 其实就是要求前一个字符串 一定要在后一个字符串集合中才返回大于0的数 
		select FIND_IN_SET('2', '1，2'); 返回2 
		select FIND_IN_SET('6', '1'); 返回0

-------------------------------------------------------

- 注意： 
 
		select * from treenodes where FIND_IN_SET(id, '1,2,3,4,5'); 
		使用find_in_set函数一次返回多条记录 
		id 是一个表的字段，然后每条记录分别是id等于1，2，3，4，5的时候 
		有点类似in （集合） 
		select * from treenodes where id in (1,2,3,4,5);	
	

