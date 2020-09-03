<!--map地图标签；name是指创建的地球的名称；type是地球的类型，类型可以是geocentric以及projected；
  version代表使用哪一版本的序列化解析插件进行解析，有两个版本，分别是EarthFileSerializer1/2-->
<map name="locgis" type="geocentric" version="2">
 
  <!--影像图层；driver是读取图层的驱动；share指是否共享该图层；visible指是否可见；url是该影像
  的原始瓦片的存放位置；cachepath指的是缓存的存放路径；cacheonly指的是是否只读缓存-->
  <image name="normalmap" driver="hgbump" shared="true" visible="false">
  <url>W:\data\dem\tile128</url>
  <cachepath>./cache/hgbump</cachepath>
  <!--cacheonly>true</cacheonly-->
  </image>
   
  <!--影像图层；driver是读取图层的驱动；url是该影像的原始瓦片的存放位置；cachepath指的是
  缓存的存放路径；-->
  <image name="GlobeImage" driver="hggis">
    <url>W:\data\image\world13\world</url>
    <cachepath>./cache/GlobeImage</cachepath>
  </image>
   
  <!--高程图层；driver是读取图层的驱动；url是该高程的原始瓦片的存放位置；cachepath指的是
  缓存的存放路径；-->
  <heightfield name="GlobeTerrain" driver="hggis">
  <url>W:\data\dem\tile15</url>
  <cachepath>./cache/GlobeTerrain</cachepath>
  </heightfield>
 
  <!--外部的配置-->
  <external>
  <!--启用晕渲图显示模式-->
  <contour_map />
  <!--是否启用法线贴图，即bump贴图；layer标签是指法线图使用的是哪一个图层的瓦片当做输入的
    法线贴图，如本例中使用了第一个影像图层normalmap作为输入的法线贴图-->
  <normal_map layer="normalmap"/>
 
  <!--启用不同级别之间的平滑过渡，图层级别切换时渐隐渐出效果-->
  <lod_blending/>
 
  <!--视点的位置；name是在场景的左下角显示的位置名称，当鼠标点击时便可以将视点移动至相应位
    置；heading、pitch代表的是偏航角以及俯仰角；lat、long、range代表纬度、经度、高度；-->
  <viewpoint name="Annotation Samples" heading="35.27" lat="33" long="-118" pitch="-35"
    range="500000"/>
 
  </external>
 
  <options>
 
  <!--设置读取地形的引擎，有mp、quadtree等多种引擎，我们目前使用的是mp，而默认设置也为mp-->
  <terrain driver="mp">
 
    <!--地形夸张，即地形的高度起伏与实际高程数据之间的倍数关系，设置为1.0则表示不进行夸张显示，
    否则数字代表夸张的倍数-->
    <vertical_scale>1.0</vertical_scale>
 
    <!--该参数将TileNode的PagedLOD的RangeModel设置为PIXEL_SIZE_ON_SCREEN或者
      DISTANCE_FROM_EYE_POINT，前者为按瓦片在屏幕上所占的像素大小进行Lod划分，而后者则依据视点
      的距离进行Lod划分，默认情况下使用后者-->
    <range_mode>DISTANCE_FROM_EYE_POINT</range_mode>
 
    <!--与rangeModel的DISTANCE_FROM_EYE_POINT配合使用，用于计算两级切换时的一个关键值，例如
      X级别的显示范围为（radius*N，MAX），X+1级别的显示范围为（0，radius*N），其中radius为当前
      瓦片的包围球的半径，N为此处设置的值，也就是在同一视点位置，N的值越大则加载的瓦片数量越多-->
    <min_tile_range_factor>6</min_tile_range_factor>
 
    <!--最大加载级别，瓦片加载到该级别后便停止加载-->
    <max_lod>23</max_lod>
    <!--最小加载级别，瓦片加载的级别不会比设置的小-->
    <min_lod>0</min_lod>
    <!--首先加载的级别-->
    <first_lod>0</first_lod>
 
    <!--是否开启混合-->
    <blending>true</blending>
    <!--灯光是否开启-->
    <lighting>false</lighting>
    <!--各个级别地形过渡的时间-->
    <lod_transition_time>0.5</ lod_transition_time >
    <!--设置裙带，地球半径*N=裙带的高度，N为skirt_ratio设置的值-->
    <skirt_ratio>0.05</skirt_ratio>
 
    <!--快速释放Node，最终起作用是在TilePagedLOD::removeExpiredChildren函数中-->
    <quick_release_gl_objects>true</quick_release_gl_objects>
 
    <!--该参数起作用在MPTerrainEngineNode::updateShaders函数中用于设置基础地球的颜色，
      也就是当没有卫片加载时，地球的颜色-->
    <color>COLOR::RED</color>
       
  </terrain>
  </options>
</map>