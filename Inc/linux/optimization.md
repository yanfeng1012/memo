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