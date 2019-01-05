1. 自定义type类型

		// src/BaseBundle/Form/Type
		namespace BaseBundle\Form\Type;
		
		use Symfony\Component\Form\AbstractType;
		use Symfony\Component\OptionsResolver\OptionsResolver;
		use Symfony\Component\Form\Extension\Core\Type\ButtonType;
		
		class UploadfileType extends AbstractType
		{
		    public function configureOptions(OptionsResolver $resolver)
		    {
		        $resolver->setDefaults(array(
		            'label'=>'文件上传',
		        ));
		    }
		
		    public function getParent()
		    {
		        return ButtonType::class;
		    }
		}

		ps:UploadfileType类名  在Type前面的名字只能有一个大写字符 否则twig就会认为是两个字符 造成不必要的麻烦

2. 自定义twig文件


		ps: 在第一行block中 _widget 前的名字为自定义type类型的文件名字 全部小写
			
		//  src/BaseBundle/Resources/views/Form/uploadfile.html.twig
		{% block uploadfile_widget %}
		   {% spaceless %}
		        {% for attrname,attrvalue in attr %}
	       		{% if attrname == 'id' %}
	       			<button type="button" data-method="offset" data-type="auto" class="layui-btn layui-btn-normal" id="{{ attrvalue }}">上传图片</button>
	        		<input type="hidden" name="bankAttachment" id="bankAttachment" value="" />
	        		<div class="Mask">
	        			<div class="upload_img_box">
	        				<h3 class="layui-clear h3">
	        					<span class="fr close_span"><i class="layui-icon">&#x1006;</i></span>
	        				</h3>
	        				<div class="content_img_box">
	        					<!---->
	
	        					<!---->
	        				</div>
	        			</div>
	        		</div>
	       		{% endif %}
		        {% endfor %}
		    {% endspaceless %}
		{% endblock %}	

3. config中进行theme注册


		twig:
		    form_themes:
		        - 'BaseBundle:Form:uploadfile.html.twig'

4. 表单生成器中使用

	    $builder->add('bankAttachment',UploadfileType::class,[
	        'label' => '银行附件',
	        'attr' => [ //自定义type的属性值在attr中进行定义
	            'class' => 'layui-form-label layui-btn upload',
	            'style'=>'width:90px;',
	            'id'=>'upload'
	        ],
	    ])

5. 页面文件中使用

		{{ form_widget(form.bankAttachment) }}
		
