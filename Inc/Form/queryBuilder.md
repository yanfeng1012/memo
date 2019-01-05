1. formtype

        $builder->add('clientName',EntityType::class,[
            'label' => '用水户名称',
            'label_attr' => [
                'class' => 'layui-form-label'
            ],
            'placeholder' => '请选择用水户名称',
            'class' => 'WaterBundle\Entity\Client',
            'choice_label' => 'name',// 必须需要显示的选项
			//$options 中包含querybuilder所需的参数
            'query_builder' => function(ClientRepository $repo) use ($options){
                return $repo->getClientByDepartmentId($options['station'],$options['roleId']);
	            },
			'choice_value' => function (ClientEntity $entity = null) { // 选项的value值
                return $entity ? $entity->getCodenum() : ''; 
            },
            'choice_attr' => function($val, $key, $index) {
                //adds a class like attending_yes, attending_no, etc
                return ['data' => $val->getNumber()];
            },
            'attr' => [
                'placeholder' => "请输入用水户名称",
                'class' => 'layui-input c-name',
                'lay-filter' => 'c-name'
            ]

		ps: ClientRepository 与 ClientEntity 都可以省略 、
			function($repo) use ($options){}
			function ($entity = null) {

2. 定义参数

		// 在configureOptions中设置参数的默认值 querybuilder中需要的参数在这里定义
	 	/**
	     * {@inheritdoc}
	     */
	    public function configureOptions(OptionsResolver $resolver)
	    {
	        $resolver->setDefaults(array(
	            'data_class' => 'WaterBundle\Entity\WaterPut',
	            'category' => '1',
	            'station' => '0',
	            'roleId'=> '2'
	        ));
	    }

3. 控制器中传值

		$form = $this->createForm('WaterBundle\Form\WaterPutType', $waterPut,['category' => $category,'station'=>$did,'roleId'=>$roleId]);