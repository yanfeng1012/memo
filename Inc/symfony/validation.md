- entity 中引用验证插件

		// src/AppBundle/Entity/Author.php
	 
		// ...
		use Symfony\Component\Validator\Constraints as Assert;（引用Assert 用于验证）
		use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity; （唯一性验证）
		 
		/**
		 * Author
		 *
		 * @ORM\Table(name="author")
		 * @ORM\Entity(repositoryClass="AdminBundle\Repository\AuthorRepository")
		 * @ORM\HasLifecycleCallbacks()
		 * @UniqueEntity(
		 *     fields={"name", "name"},
		 *     message="{{ value }}已存在"
		 * )
		 */
		class Author
		{
		    /**
		     * @Assert\NotBlank(message="名称不能为空") （采用注释的方式进行验证方式填写）
		     */
		    public $name;
		}

- 使用验证服务

		// ...
		use Symfony\Component\HttpFoundation\Response;
		use AppBundle\Entity\Author;
		 
		// ...
		public function authorAction()
		{
		    $author = new Author();
		 
		    // ... do something to the $author object
		    // ... 对 $author 对象做一些事
		 
		    $validator = $this->get('validator');
		    $errors = $validator->validate($author);
		 
		    if (count($errors) > 0) {
		    return $this->render('author/validation.html.twig', array(
		        'errors' => $errors,
		    ));
		}

- 在twig中输出错误提示

		{# app/Resources/views/author/validation.html.twig #}
		<h3>The author has the following errors</h3>
		<ul>
		{% for error in errors %}
		    <li>{{ error.message }}</li>
		{% endfor %}
		</ul>

- 相关配置

		Symfony的validator是默认开启的，但是如果你使用annotation方式来指定约束，必须显式地开启（用于验证的）annotation：

		# app/config/config.yml
		framework:
		    validation: { enable_annotations: true }

- 约束配置

		choice 

		// src/AppBundle/Entity/Author.php
		 
		// ...
		use Symfony\Component\Validator\Constraints as Assert;
		 
		class Author
		{
		    /**
		     * @Assert\Choice(
		     *     choices = { "male", "female", "other" },
		     *     message = "Choose a valid gender."
		     * )
		     */
		    public $gender;
		 
		    // ...
		}

 - 属性约束

			// src/AppBundle/Entity/Author.php
			 
			// ...
			use Symfony\Component\Validator\Constraints as Assert;
			 
			class Author
			{
			    /**
			     * @Assert\NotBlank()
			     * @Assert\Length(min=3)
			     */
			    private $firstName;
			}

 - Getters约束 

			约束也可以应用于方法的返回值。Symfony允许你把一个约束添加到任何“get”、“is” 或者 “has”开头的public方法。
			这一类方法被称为“getters”。
			
			这种技巧的好处是允许你动态验证你的对象。例如，假设你想确保密码字段不能匹配到用户的firstname(出于安全原因)。
			你可以通过创建一个 isPasswordLegal 方法，然后断言该方法必须返回 true 来实现:
			
			// src/AppBundle/Entity/Author.php
			 
			// ...
			use Symfony\Component\Validator\Constraints as Assert;
			 
			class Author
			{
			    /**
			     * @Assert\IsTrue(message = "The password cannot match your first name")
			     */
			    public function isPasswordLegal()
			    {
			        // ... return true or false
			    }
			}
			
			现在，创建一个 isPasswordLegal() 方法，含有你所需的逻辑：
			
			public function isPasswordLegal()
			{
			    return $this->firstName !== $this->password;
			}
			
			眼尖的人可能会注意到，在YAML, XML和PHP的约束配置格式中，getter的前缀(“get”、”is” 或者 “has”) 在映射时被忽略了。
			这能让你在不改变验证逻辑的前提下，把一个约束移动到后面的一个同名属性之上（反之亦然）。