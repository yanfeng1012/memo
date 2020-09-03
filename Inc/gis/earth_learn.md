<!--map��ͼ��ǩ��name��ָ�����ĵ�������ƣ�type�ǵ�������ͣ����Ϳ�����geocentric�Լ�projected��
  version����ʹ����һ�汾�����л�����������н������������汾���ֱ���EarthFileSerializer1/2-->
<map name="locgis" type="geocentric" version="2">
 
  <!--Ӱ��ͼ�㣻driver�Ƕ�ȡͼ���������shareָ�Ƿ����ͼ�㣻visibleָ�Ƿ�ɼ���url�Ǹ�Ӱ��
  ��ԭʼ��Ƭ�Ĵ��λ�ã�cachepathָ���ǻ���Ĵ��·����cacheonlyָ�����Ƿ�ֻ������-->
  <image name="normalmap" driver="hgbump" shared="true" visible="false">
  <url>W:\data\dem\tile128</url>
  <cachepath>./cache/hgbump</cachepath>
  <!--cacheonly>true</cacheonly-->
  </image>
   
  <!--Ӱ��ͼ�㣻driver�Ƕ�ȡͼ���������url�Ǹ�Ӱ���ԭʼ��Ƭ�Ĵ��λ�ã�cachepathָ����
  ����Ĵ��·����-->
  <image name="GlobeImage" driver="hggis">
    <url>W:\data\image\world13\world</url>
    <cachepath>./cache/GlobeImage</cachepath>
  </image>
   
  <!--�߳�ͼ�㣻driver�Ƕ�ȡͼ���������url�Ǹø̵߳�ԭʼ��Ƭ�Ĵ��λ�ã�cachepathָ����
  ����Ĵ��·����-->
  <heightfield name="GlobeTerrain" driver="hggis">
  <url>W:\data\dem\tile15</url>
  <cachepath>./cache/GlobeTerrain</cachepath>
  </heightfield>
 
  <!--�ⲿ������-->
  <external>
  <!--��������ͼ��ʾģʽ-->
  <contour_map />
  <!--�Ƿ����÷�����ͼ����bump��ͼ��layer��ǩ��ָ����ͼʹ�õ�����һ��ͼ�����Ƭ���������
    ������ͼ���籾����ʹ���˵�һ��Ӱ��ͼ��normalmap��Ϊ����ķ�����ͼ-->
  <normal_map layer="normalmap"/>
 
  <!--���ò�ͬ����֮���ƽ�����ɣ�ͼ�㼶���л�ʱ��������Ч��-->
  <lod_blending/>
 
  <!--�ӵ��λ�ã�name���ڳ��������½���ʾ��λ�����ƣ��������ʱ����Խ��ӵ��ƶ�����Ӧλ
    �ã�heading��pitch�������ƫ�����Լ������ǣ�lat��long��range����γ�ȡ����ȡ��߶ȣ�-->
  <viewpoint name="Annotation Samples" heading="35.27" lat="33" long="-118" pitch="-35"
    range="500000"/>
 
  </external>
 
  <options>
 
  <!--���ö�ȡ���ε����棬��mp��quadtree�ȶ������棬����Ŀǰʹ�õ���mp����Ĭ������ҲΪmp-->
  <terrain driver="mp">
 
    <!--���ο��ţ������εĸ߶������ʵ�ʸ߳�����֮��ı�����ϵ������Ϊ1.0���ʾ�����п�����ʾ��
    �������ִ�����ŵı���-->
    <vertical_scale>1.0</vertical_scale>
 
    <!--�ò�����TileNode��PagedLOD��RangeModel����ΪPIXEL_SIZE_ON_SCREEN����
      DISTANCE_FROM_EYE_POINT��ǰ��Ϊ����Ƭ����Ļ����ռ�����ش�С����Lod���֣��������������ӵ�
      �ľ������Lod���֣�Ĭ�������ʹ�ú���-->
    <range_mode>DISTANCE_FROM_EYE_POINT</range_mode>
 
    <!--��rangeModel��DISTANCE_FROM_EYE_POINT���ʹ�ã����ڼ��������л�ʱ��һ���ؼ�ֵ������
      X�������ʾ��ΧΪ��radius*N��MAX����X+1�������ʾ��ΧΪ��0��radius*N��������radiusΪ��ǰ
      ��Ƭ�İ�Χ��İ뾶��NΪ�˴����õ�ֵ��Ҳ������ͬһ�ӵ�λ�ã�N��ֵԽ������ص���Ƭ����Խ��-->
    <min_tile_range_factor>6</min_tile_range_factor>
 
    <!--�����ؼ�����Ƭ���ص��ü�����ֹͣ����-->
    <max_lod>23</max_lod>
    <!--��С���ؼ�����Ƭ���صļ��𲻻�����õ�С-->
    <min_lod>0</min_lod>
    <!--���ȼ��صļ���-->
    <first_lod>0</first_lod>
 
    <!--�Ƿ������-->
    <blending>true</blending>
    <!--�ƹ��Ƿ���-->
    <lighting>false</lighting>
    <!--����������ι��ɵ�ʱ��-->
    <lod_transition_time>0.5</ lod_transition_time >
    <!--����ȹ��������뾶*N=ȹ���ĸ߶ȣ�NΪskirt_ratio���õ�ֵ-->
    <skirt_ratio>0.05</skirt_ratio>
 
    <!--�����ͷ�Node����������������TilePagedLOD::removeExpiredChildren������-->
    <quick_release_gl_objects>true</quick_release_gl_objects>
 
    <!--�ò�����������MPTerrainEngineNode::updateShaders�������������û����������ɫ��
      Ҳ���ǵ�û����Ƭ����ʱ���������ɫ-->
    <color>COLOR::RED</color>
       
  </terrain>
  </options>
</map>