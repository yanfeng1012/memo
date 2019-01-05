### 用来定义字段的类型

- 一些字段常用的type：
	
		string：字符串类型，对应varchar

		integer：int类型

		smallint：短int类型

		bigint：长int类型

		boolean：布尔类型

		decimal：对应数据库decmail类型，双精度类型

		datetime：日前datetime类型

		time：time类型

		text：文本类型

		float：浮点类

### 其他

	name: 字段的名称
	
	length ： 字段的长度
	
	unique ：字段在数据库中的长度，只支持string类型使用
	
	nullable ： 数据库是否为空
	
	options：条件组合
	下面常见的有

	default ：字段默认值
	
	unsigned ： 非负数
	
	comment ： 字段说明注释

### 使用@ORM\Entity指定repository

	<?php
	/**
	 * @ORM\Entity(repositoryClass="MyProject\UserRepository")
	 */
	classUser
	{
	  //...
	}

### 使用@ORM\Table对表重新定义

	name : 定义表的名字
	indexes ： 定义一组索引
	uniqueConstraints ： 定义一组约束

	<?php
	/**
	* @Entity
	* @Table(name="user",
	*      uniqueConstraints={@UniqueConstraint(name="user_unique",columns={"username"})},
	*      indexes={@Index(name="user_idx",
	 columns={"email"})}
	* )
	*/
	classUser{}

### 使用@ORM\Index定义一个索引

	<?php
	/**
	* @ORM\Entity
	* @ORM\Table(name="ecommerce_products",indexes={@ORM\Index(name="search_idx",
	 columns={"name", "email"}, options={"where": "(((id IS NOT NULL) AND (name IS NULL)) AND (email IS NULL))"})})
	*/
	classECommerceProduct
	{
	}

### 使用@ORM\HasLifecycleCallbacks 做事件回调

	<?php
	/**
	* @ORM\Entity
	* @ORM\HasLifecycleCallbacks
	*/
	classUser
	{
	   /**
	     * @ORM\PrePersist()
	     */
	    public function prePersist()
	    {
	        if($this->getCreateAt() == null){
	            $this->setCreateAt(new \DateTime());
	        }
	        $this->setUpdateAt(new \DateTime());
	    }
	
	    /**
	     * @ORM\PreUpdate()
	     */
	    public function preUpdate()
	    {
	        $this->setUpdateAt(new \DateTime());
	    }
	
	ps:可以使用一下事件
	   @ORM\PostLoad, 
	   @ORM\PrePersist,
	   @ORM\PostPersist, 
	   @ORM\PreRemove,
	   @ORM\PostRemove, 
	   @ORM\PreUpdate or @ORM\PostUpdate 
	   触发一个回调。
