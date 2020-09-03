## OSG（OpenSceneGraph）

- 简介

	- OpenSceneGraph是一个开放源码，跨平台的图形开发包。
	- 基于OpenGL的软件接口。
	- 标准c++语法
	- 为图形图像的开发提供场景管理和图形渲染优化的功能。
	
-  核心库（19个核心库）

	- **osg**库：基本数据类型，负责提供基本场景图类，构建场景图形节点；
	- **osgUtil** 库：工具类库，提供通用的公用类，用于操作场景图形及内容；
	- **osgDB**库：数据的读写库，负责提供场景中数据的读写工作；
	- **osgViewer**库：视窗管理库，提供osg与各种GUI的结合。
	- **osgFx**库：特殊效果节点工具，用于渲染特效节点；
	- **osgParticle**库：粒子系统的节点工具，用于模拟各种天气或者自然现象；	- **osgSim**库：虚拟仿真效果的节点工具，用于特殊渲染；
	- **osgTerrain**库：生成地形数据的节点工具，用于渲染高程数据；
	- **osgText**库：文字节点工具，用于向场景中添加文字信息；
	- **osgShadow**库：阴影节点工具，用于向场景中添加实时阴影，提高场景渲染的真实性。

- 超级指针

	- 超级指针为用户提供了一种自动内存释放的机制；
	- 智能指针模板的应用对象**必须派生自Referenced类**，否则模板将无法使用；

- 视景器

	- 场景树

		场景树节点采用自顶向下的、分层的树状数据结构来组织空间数据集，以提升渲染的效率。
		
	- 节点类型

		- 三大基本节点类
			- `osg::Node` 
			 
				为结点类，下有派生类无数，是OSG中最重要的类之一，也是最常用的类之一
				
			- `osg::Geode`
			
				Geode结点，是个几何结点，可以说是一个几何Group结点，一般的可绘制几何体都是通过它来传向root进行渲染。是OSG几何绘制的最高管理结点。
				
			- `osg::Group`
		- 扩展节点
			- `osg::MatrixTransform`

				矩阵变换节点（osg::MatrixTransform）继承自osg::Transform，其主要作用是负责场景中的矩阵变换、矩阵的运算及坐标系的变换。通过使用矩阵变换节点可以对场景中的模型进行旋转、平移等操作。加入此矩阵变换节点的模型，均会被此矩阵变化作用。 
			
			- `osg::AutoTransform`

				自动对齐节点继承自osg::Transform，它的主要作用是使节点自动对齐摄像机或屏幕。在实际应用中，通常可以用来显示一些不变化的文字或者其他的标识
			
			- `osg::Lod`

				LOD是Level Of Detail 的缩写，LOD允许程序根据摄像机与物体的距离，来决定使用哪个模型
				
- 模型控制（坐标系为**右手定则**）

		旋转 > 平移 > 缩放

		osg::ref_ptr<osg::MatrixTransform> rpTranslate = new osg::MatrixTransform;		rpTranslate->addChild(rpNode.get());		//向上平移2个单位		rpTranslate->setMatrix(osg::Matrix::translate(0, 0, 2)) ;		//向下平移2个单位并缩放0.5倍		rpScale->setMatrix(osg::Matrix::scale(0.5, 0.5, 0.5)*osg::Matrix::translate(0, 0, -2)) ;		//向右平移4个单位且缩放0.5倍且旋转45度		rpRotate->setMatrix(osg::Matrix::rotate(osg::DegreesToRadians(45.0), 1, 0, 0)*osg::Matrix::scale(0.5, 0.5, 0.5)*osg::Matrix::translate(4, 0, 0)) ;	
	
- 事件处理

	- 状态事件处理器类：osgViewer::StatsHandler	- 窗口大小事件处理器类：osgViwer::WindowSizeHandler	- 模型的网格、点模式的事件处理器类： osgGA::StateSetManipulator

	- 事件添加

			addEventHandler() //事件添加句柄

			//开启网格和灯光 w键			viewer.addEventHandler(new osgGA::StateSetManipulator(viewer.getCamera()->getOrCreateStateSet()));			//窗口大小变化事件 f键			viewer.addEventHandler(new osgViewer::WindowSizeHandler);			//开启帧率 s键			viewer.addEventHandler(new osgViewer::StatsHandler);
			
	- 自定义事件

		>viewer的主要功能是控制场景，它是场景的核心类，通过viewer的addEventHandler方法来添加一个事件处理器，自定义的事件处理器必须继承自osgGA::GUIEventHandler，通过鼠标或键盘事件响应时可以获取viewer进而控制整个场景。
		
		- 鼠标时间 PUSH      getButton()
		- 键盘时间 KEYDOWN   getKey()
		- GUIEventAdapter  获取 键盘鼠标等事件是否为1
			
- 图元绘制

	ps: push_back()函数,将一个新的元素加到vector的最后面，位置为当前最后一个元素的下一个元素
		[四种强制类型转换](http://c.biancheng.net/view/2343.html)
	- 绘制类
		- **osg::Geode**类：叶子节点类，用来管理几何体类型的数据，供场景渲染使用；		- **osg::Drawable**类：纯虚类，作为绘制对象的基类，派生出常用的osg::Geometry、 osg::ShapeDrawable类；		- **osg::Geometry**类：几何体类，指定绘制几何体的顶点及对数据的解析，设置顶点、法线、颜色、纹理坐标等数据，设置绑定方式，数据解析，最后加入到叶节点绘制并渲染；		- **osg::ShapeDrawable**类：预定义几何体类，比如长方体、正方体、球等。	

	
		