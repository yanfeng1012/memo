## FromBuilder

1. EntityType

		$form = $this->createFormBuilder($user)
         ->add('username')
         ->add('password', PasswordType::class)
         ->add('repassword', PasswordType::class, [
             'mapped' => false // 添加Entity额外的字段
         ])
         ->add('roles', EntityType::class, [
             'class' => 'KitRbacBundle:Role',
             'choice_label' => 'rolename',
             'label' => '用户组'
         ])
         ->getForm();
	 ps: 默认choice_value 为ID

		或者

		->add('hTQ', EntityType::class, [
            'class' => 'SystemBundle:Code',
            'label' => '合同期',
            'query_builder' => function ($repo) use ($options) {
                return $repo->createQueryBuilder('c')
                    ->where('c.codetypeid = :codetypeid')
                    ->setParameter('codetypeid', $options['hTQ']);
            },
            'choice_value' => function ($entity = null) {
                return $entity ? $entity->getCodenum() : '';
            },
            'choice_label' => 'codename',
            'attr' => [
                'name' => 'hTQ'
            ]

### query builder

[详解](./queryBuilder.md)

		$builder
	        ->add('parent', EntityType::class, [
	            'class' => 'KitNewsBundle:Category',
	            'query_builder' => function(CategoryRepository $repo){
	                return $repo->getParentCategory();//自定义查询方法
	            },
	            'choice_label' => 'name',
	            'label' => '父级分类'
	        ]);
		// query
		class CategoryRepository extends \Doctrine\ORM\EntityRepository
		{
		
		    public function getParentCategory()
		    {
		        return $this->createQueryBuilder('c')
		            ->select('c')
		            ->where('c.parentId = 1')
		            ->andWhere('c.status = 1')
		            ->orderBy('c.id', 'ASC');
		    }
		}

2. ChoiceType

-	两个关键参数
	
		
	<table cellpadding="0" border="1" cellspacing="0" style="text-align: center;width: 100%;">
		<tr>
			<th>目的类型</th>
			<th>expanded</th>
			<th>multiple</th>
		</tr>
		<tr>
			<td>单选下拉框(select)</td>
			<td>false</td>
			<td>false</td>
		</tr>
		<tr>
			<td>复选下拉框(multi-select)</td>
			<td>false</td>
			<td>true</td>
		</tr>
		<tr>
			<td>单选框（radio）</td>
			<td>true</td>
			<td>false</td>
		</tr>
		<tr>
			<td>复选框（checkboxes）</td>
			<td>true</td>
			<td>true</td>
		</tr>
	</table>		
		
		// 为radio设置属性
		 $builder ->add('status', ChoiceType::class, [
		     'choices' => [
		         '启用' => 1,
		         '禁用' => 0
		     ],
		     'expanded' => true,
		     'label' => '状态',
		     'data' => $options['data_status'], //默认选中项的值
		     'label_attr' => [
		         'class' => 'radio-inline'
		     ],
		     'choice_attr' => function ($val, $key, $index) {
		         // adds a class like attending_yes, attending_no, etc
		         return [
		             'lay-filter' => 'status-radio'
		         ];
		     }
		 ])
			
		或者

		add('xSFJ', ChoiceType::class, [
            'label' => '县司法局',
            'choices' => $options['xjgbms'],
        ])
		$xjgbms 是array

3. RepeatedType

		$builder->add('name', TextType::class, [
	         'label' => '用户名'
	     ])
	         ->add('email', EmailType::class, [
	         'label' => '邮箱'
	     ])
	         ->add('plainPassword', RepeatedType::class, [
	         'type' => PasswordType::class,
	         'first_options' => ['label' => '密码'],
	         'second_options' => ['label' => '确认密码'],
	     ]);

4. options

		public function buildForm(FormBuilderInterface $builder, array $options)
		 {
		     $builder->add('name', null, [
		         'label' => '类别名称',
		         'attr' => [
		             'lay-verify' => "required",
		             'placeholder' => "请输入类别名称",
		             'autocomplete' => "off"
		         ]
		     ])
		         ->add('status', ChoiceType::class, [
		         'choices' => [
		             '启用' => 1,
		             '禁用' => 0
		         ],
		         'expanded' => true,
		         'label' => '状态',
		         'data' => $options['data_status'], // 默认选中项的值
		         'label_attr' => [
		             'class' => 'radio-inline'
		         ],
		         'choice_attr' => function ($val, $key, $index) {
		             // adds a class like attending_yes, attending_no, etc
		             return [
		                 'lay-filter' => 'status-radio'
		             ];
		         }
		     ])
		         ->add('submit', SubmitType::class, [
		         'label' => '提交',
		         'attr' => [
		             'lay-submit' => 1,
		             'lay-filter' => "formDemo"
		         ]
		     ]);
		 }
		
		 /**
		  *
		  * {@inheritdoc}
		  *
		  */
		 public function configureOptions(OptionsResolver $resolver)
		 {
		     $resolver->setDefaults(array(
		         'data_class' => 'DispatchBundle\Entity\CanalCategory',
		         'data_status' => 1
		     ));
		 }
