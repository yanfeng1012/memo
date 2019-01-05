## 一对多

	// category entity
	  /**
	   * Many Crops have One CropsCategory.
	   *
	   * @ORM\OneToMany(targetEntity="Crops", mappedBy="category")
	   * @ORM\OrderBy({"id" = "DESC"})
	   */
	  private $crops;
	  
	  public function __construct()
	  {
	      $this->canals = new ArrayCollection();
	  }
	
	  public function getCrops()
	  {
	      return $this->crops;
	  }
	  // crops entity
	  /**
	   * One Crops have One CropsCategory.
	   *
	   * @ORM\ManyToOne(targetEntity="CropsCategory", inversedBy="crops")
	   * @ORM\JoinColumn(name="category_id", referencedColumnName="id", onDelete="CASCADE")
	   */
	  private $category;
	  
	  public function getCategory()
	  {
	      return $this->category;
	  }
	  
	  public function setCategory(CropsCategory $category)
	  {
	      $this->category = $category;
	      
	      return $this;
	  }

## 自己对自己
	
	  /**
	   * @var int
	   *
	   * @ORM\Column(name="parent_id", type="integer")
	   */
	  private $parentId;
	  /**
	   * One Canal has Many Canals.
	   *
	   * @ORM\ManyToOne(targetEntity="Canal", inversedBy="children")
	   * @ORM\JoinColumn(name="parent_id", referencedColumnName="id", onDelete="CASCADE")
	   */
	  private $parent;
	  
	  /**
	   * Many Canals have One Canal.
	   *
	   * @ORM\OneToMany(targetEntity="Canal", mappedBy="parent")
	   * @ORM\OrderBy({"node" = "ASC", "id" = "DESC"})
	   */
	  private $children;
	
	  public function __construct()
	  {
	      $this->children = new ArrayCollection();
	  }
	
	  /**
	   * Set parent
	   *
	   * @param Canal $parent
	   *
	   * @return Canal
	   */
	  public function setParent(Canal $parent = null)
	  {
	      $this->parent = $parent;
	      
	      return $this;
	  }
	  
	  /**
	   * Get parent
	   *
	   * @return Canal 	
	   */
	  public function getParent()
	  {
	      return $this->parent;
	  }
	  
	  public function getChildren()
	  {
	      return $this->children;
	  }