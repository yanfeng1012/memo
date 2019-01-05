1. 在页面中引入jquery和circleChart.min.js文件。

		<script src="path/to/jquery.min.js"></script>
		<script src="path/to/circleChart.min.js"></script>　

2. HTML结构

		使用一个<div>元素作为该圆形百分比进度条的HTML结构：
		<div class="circleChart" id="circle1"></div>

3. 初始化插件

		在页面DOM元素加载完毕，可以通过circleChart()方法来初始化该圆形百分比进度条插件。
		$("#circle1").circleChart();

4. 配置参数

		color: "#3459eb", // 进度条颜色
		backgroundColor: "#e6e6e6", // 进度条之外颜色
		background: true, // 是否显示进度条之外颜色
		speed: 2000, // 出现的时间
		widthRatio: 0.2, // 进度条宽度
		value: 66,  // 进度条占比
		unit: "percent",
		counterclockwise: false, // 进度条反方向
		size: 110, // 圆形大小
		startAngle: 0, // 进度条起点
		animate: true, // 进度条动画
		backgroundFix: true,
		lineCap: "round",
		animation: "easeInOutCubic",
		text: false, // 进度条内容
		redraw: false,
		cAngle: 0,
		textCenter: true,
		textSize: false,
		textWeight: "normal",
		textFamily: "sans-serif",
		relativeTextSize: 1 / 7, // 进度条中字体占比
		autoCss: true,
		onDraw: false