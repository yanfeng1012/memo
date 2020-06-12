## linux 性能优化

- 平均负载

>是指单位时间内，系统处于可运行状态和不可中断状态的平均进程数，也就是**平均活跃进程数**，它**和 CPU 使用率并没有直接关系**。

- 查询系统CPU信息

		cat /proc/cpuinfo | grep "model name"
		
- 系统平均负载变化情况

		watch -d uptime
		
- stress 

>是一个 Linux 系统压力测试工具，这里我们用作异常进程模拟平均负载升高的场景。

- sysstat 

>包含了常用的 Linux 性能工具，用来监控和分析系统的性能。

	mpstat 是一个常用的多核 CPU 性能分析工具，用来实时查看每个 CPU 的性能指标，以及所有 CPU 的平均指标。
	
	pidstat 是一个常用的进程性能分析工具，用来实时查看进程的 CPU、内存、I/O 以及上下文切换等性能指标。
	
- mpstat 查看cpu 变化情况

		# -P ALL 表示监控所有CPU，后面数字5表示间隔5秒后输出一组数据
		$ mpstat -P ALL 5
		Linux 4.15.0 (ubuntu) 09/22/18 _x86_64_ (2 CPU)
		13:30:06     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
		13:30:11     all   50.05    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00   49.95
		13:30:11       0    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
		13:30:11       1  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
		
- pidstat 查看进程占用情况

		# 间隔5秒后输出一组数据
		$ pidstat -u 5 1
		13:37:07      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command
		13:37:12        0      2962  100.00    0.00    0.00    0.00  100.00     1  stress
		
		# 间隔5秒后查看上下文切换 -t 查看线程
		$ pidstat -wt 5 
		12时20分54秒       PID   cswch/s nvcswch/s  Command		12时20分59秒        13      0.80      0.00  ksoftirqd/2		12时20分59秒        19      0.20      0.00  migration/4		12时20分59秒        25      0.80      0.00  ksoftirqd/5
		
		cswch  ，表示每秒自愿上下文切换（voluntary context switches）的次数
		nvcswch  ，表示每秒非自愿上下文切换（non voluntary context switches）的次数。
		
- 上下文切换分析

		# 每隔5秒输出1组数据
		$ vmstat 5
		procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
		 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
		 0  0      0 7005360  91564 818900    0    0     0     0   25   33  0  0 100  0  0
		 
		cs（context switch）是每秒上下文切换的次数。
		in（interrupt）则是每秒中断的次数。
		r（Running or Runnable）是就绪队列的长度，也就是正在运行和等待 CPU 的进程数。
		b（Blocked）则是处于不可中断睡眠状态的进程数。
		
- 中断信息查询

		$ watch -d cat /proc/interrupts

- 系统CPU和任务统计信息

		$ cat /proc/stat | grep ^cpu
		
- 查看所有的CPU内容 学会使用 **man proc**

- [**top**](https://www.cnblogs.com/niuben/p/12017242.html)

	- 按下数字 **1** 切换到每个CPU的使用率

- perf top / perf report / perf record -g

>能够实时显示占用 CPU 时钟最多的函数或者指令

- 压力测试 [**ab**](https://www.cnblogs.com/myvic/p/7703973.html)

		# 并发10个请求测试Nginx性能，总共测试100个请求
		$ ab -c 10 -n 100 http://192.168.124.28:8080
		This is ApacheBench, Version 2.3 <$Revision: 1706008 $>
		Copyright 1996 Adam Twiss, Zeus Technology Ltd, 
		...
		Requests per second:    11.63 [#/sec] (mean)
		Time per request:       859.942 [ms] (mean)
		...