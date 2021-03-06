## 算法

### 特性
- 有穷性
- 确定性
- 可行性
- 输入
- 输出

### 算法设计技术

- 分治法

	- 基本步骤
		- 1、分解
		 
		 	将原问题分解为若干个规模较小，相互独立，与原问题形式相同的子问题
				
		- 2、解决
		
			若子问题规模较小而容易被解决则直接解，否则递归地解各个子问题
		
		- 3、合并

			将各个子问题的解合并为原问题的解
			
- 动态规划法

	
	- 与分治法的不同

		适合用动态规划法求解的问题，经分解得到的子问题往往不是独立的。若用分治法来解这类问题，则相同的子问题会被求解多次，以至于最后解决原问题耗费指数级时间。
	
	- 基本思路

		用一张表来记录所有已解决的子问题的答案。不管该子问题以后是否用到，只要他被计算过，就将其结果填入表中。
		
	- 基本步骤

		- 1、找出最优解的性质，并刻画其结构特性。
		- 2、递归地定义最优解的值。
		- 3、以自底向上的方式计算出最优解。
		- 4、根据计算最优值时得到的信息，构造一个最优解。

- 贪心法

	- 概念

		- 所谓贪心算法是指，在对问题求解时，**总是做出在当前看来是最好的选择**。也就是说，不从整体最优上加以考虑，它所做出的仅仅是在某种意义上的**局部最优解**。
		- 贪心算法没有固定的算法框架，算法设计的关键是贪心策略的选择。必须注意的是，贪心算法不是对所有问题都能得到整体最优解，选择的贪心策略必须具备无后效性（即某个状态以后的过程不会影响以前的状态，只与当前状态有关。）
		- 所以，对所采用的贪心策略一定要仔细分析其是否满足无后效性。

	- 贪心法产生优化解的条件

		- 贪心选择性
		
				若一个优化问题的全局优化解可以通过局部优化解选择得到，则该问题称为具有贪心选择性。
		- 优化子结构

				若一个优化问题的优化解包含它的子问题的优化解，则称其具有优化子结构
- 回溯法

	- 概念
	
		回溯法（探索与回溯法）是一种选优搜索法，又称为试探法，按选优条件向前搜索，以达到目标。但当探索到某一步时，发现原先选择并不优或达不到目标，就退回一步重新选择，这种走不通就退回再走的技术为回溯法。
		
- [分支限界法](https://www.cnblogs.com/chinazhangjie/archive/2010/11/01/1866136.html)

	- 分支限界法与回溯法
	
		- （1）求解目标：回溯法的求解目标是找出解空间树中满足约束条件的所有解，而分支限界法的求解目标则是找出满足约束条件的一个解，或是在满足约束条件的解中找出在某种意义下的最优解。 
		
		- （2）搜索方式的不同：回溯法以深度优先的方式搜索解空间树，而分支限界法则以广度优先或以最小耗费优先的方式搜索解空间树。

	
- [概率算法](https://baike.baidu.com/item/%E6%A6%82%E7%8E%87%E7%AE%97%E6%B3%95/6415410?fr=aladdin)
- [近似算法](https://baike.baidu.com/item/%E8%BF%91%E4%BC%BC%E7%AE%97%E6%B3%95/5963315?fr=aladdin)