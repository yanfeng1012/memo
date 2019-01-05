- 定义扩展类

		// BaseBundle/Twig/CodeExtension
		<?php
		namespace BaseBundle\Twig;
		
		use Symfony\Bridge\Doctrine\RegistryInterface; //symfony3.4使用可以是RegistryInterface或者Registry
		
		class CodeExtension extends \Twig_Extension
		{
		    private $doctrine;
		
		    public function __construct(RegistryInterface $doctrine)
		    {
		        $this->doctrine = $doctrine;
		    }
		
			
		    public function getFunctions()
		    {
		      //第一个参数是Twig中使用的function名 : 比如 {{ code_name($codenum,$codetypeid) }} 
	              //第二个参数是个回调 调用下面编写的function方法
		        return array(
		            new \Twig_SimpleFunction('code_name', array($this,'codeName')),
		            new \Twig_SimpleFunction('code_type_name', array($this,'codeTypeName')),
		        );
		    }
		
			public function getFilters()
		    {
		        return array(
		            //第一个参数是Twig中使用的Filter名 : 比如 {{ foo | number_format_decimal }} 这样foo会作为参数传递过来
		            //第二个参数是个回调 调用下面编写的Filter方法
		            new \Twig_SimpleFilter('number_format_decimal', array($this, 'number_format_decimal_Filter')),
		        );
		    }

		    public function codeName($codenum,$codetypeid)
		    {
		        /**
		         * @var \SystemBundle\Repository\CodeRepository $codeRepo
		         */
		        $codeRepo = $this->doctrine->getRepository('SystemBundle:Code');
		        $codename = $codeRepo->getcodeName($codenum,$codetypeid);
		        return empty($codename) ? '暂无' : $codename;
		    }
		
		    public function codeTypeName($codetypeId)
		    {
		        /**
		         * @var \SystemBundle\Repository\CodeTypeRepository $codeTypeReop
		         */
		        $codeTypeReop = $this->doctrine->getRepository('SystemBundle:CodeType');
		        $codeType = $codeTypeReop->find($codetypeId);
		        return empty($codeType) ? '暂无' : $codeType->getName();
		    }

		    public function number_format_decimal_Filter($number)
		    {
		        //这里是你的Filter
		        return number_format( $number);
		    }
		}


- service 注册

		code.twig.extension:
	        class: BaseBundle\Twig\CodeExtension
	        arguments: ["@doctrine"] //在app下的service中会进行自动加载service ID 但是在bundle下需要手动填写
	        tags:
	            - { name: twig.extension }

- config 中定义变量

		parameters:
		    locale: en
		    uploads_directory: '%kernel.root_dir%/../web/uploads' //自定义文件上传保存位置

	    file_uploader:
		    class: BaseBundle\Service\UploadFileService
		    arguments: ["%uploads_directory%","@service_container"] //在service注册时 参数中调用（%参数% 在双百分号之间进行调用）
