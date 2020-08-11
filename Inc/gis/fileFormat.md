## 常见文件格式

- 常见模式

|模式名称|扩展名|描述|
|:--:|:--:|:--|
|Web Map Service|WMS|是OGC标准中的网络地图服务，支持获取服务能力、获取地图和获取对象信息操作。|
|Web Map Tile Service|WMTS|是OGC标准中的网络地图瓦片服务，提供了一种采用预定义图块方法发布数字地图服务的标准化解决方案，弥补了WMS不能提供分块地图的不足。|
|Web Converage Service|	WCS|是OGC标准中的网络地理覆盖服务，提供的是包含了地理位置信息或属性的空间栅格图层，而不是静态地图的访问。|
|Web Feature Service|WFS|是OGC标准中的网络要素服务，支持基于地理要素级别的数据共享和数据操作。|
|Tile Map Service|TMS|是OSGeo制定的一个瓦片地图服务标准，将地图按金字塔切片为多个缩放级别的图像。|

- 常见地图格式

|数据类型|模式名称|扩展名|描述|
|:--:|:--:|:--:|:--|
|栅格数据|GeoTIFF|	.tif/.tiff|是超过160个不同的遥感、地信、制图组织建立的以TIFF为基础的地理栅格交换格式，可用于存储影像、高程等栅格数据。|
|栅格数据|ERDAS IMAGINE|.img|是美国ERDAS 公司制定的用于存储较大栅格数据的文件格式。|
|栅格数据|MBTiles|.db/.mbtiles|是一种为了即时使用和高效传输而通过SQLite数据库存储瓦片地图数据的标准。|
|矢量数据|ESRI Shapefile	|.shp|是ESRI开发的一种空间数据开放格式，是目前比较常用的一种矢量交换格式。|
|矢量数据|Keyhole Markup Language|	.kml|	KML，是一种基于XML语法与格式的标记语言，主要用于描述和保存地理信息（如点、线、图像、多边形和模型等）的编码规范。|
|矢量数据|KMZ|	.kmz|KMZ文件是压缩过的KML文件，它不仅能包含 KML文本，也能包含其他类型的文件，比如图片文件。|

- 常见模型格式

|模型格式|扩展名|描述|
|:--:|:--:|:--|
|OSG|.osg|OpenSceneGraph原生的文本格式的模型文件。|
|OSGB|.osgb|	Open Scene Gragh Binary，是二进制存贮的、带有嵌入式链接纹理数据的模型格式。|
|IVE|.ive|OpenSceneGraph原生的二进制格式的模型文件，带有嵌入式链接纹理数据。|
|3DS|.3ds|3DS是3DMax建模软件的衍生文件格式，建模后可导出成3DS格式，可与其他建模软件兼容，也可用于渲染。|
|OBJ|.obj|Alias Wavefront公司为它的一套基于工作站的3D建模和动画软件开发的一种标准3D模型文件格式，很适合用于3D软件模型之间的互导，也可以通过Maya读写。|
|FLT|.flt|OpenFlight是 Multigen Paradigm Inc公司的一种公开格式。|
|FBX|.fbx|Autodesk FBX是Autodesk公司出品的一款用于跨平台的免费三维创作与交换格式的软件，FBX 文件格式支持所有主要的三维数据元素以及二维、音频和视频媒体元素。|
|DAE|.dae|DAE文件格式是三维交互文件格式，一般用于多个图形程序之间交换数字数据，谷歌地球的模型就是DAE。|

