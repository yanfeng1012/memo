## DataFixtures 

- install 

		 composer require --dev doctrine/doctrine-fixtures-bundle

- MenuBundle/DataFixture	s/MenuFixtures.php
	
		<?php
		namespace MenuBundle\DataFixtures;
		
		use Doctrine\Bundle\FixturesBundle\Fixture;
		use Doctrine\Common\Persistence\ObjectManager;
		use MenuBundle\Entity\Menu;
		
		class MenuFixtures extends Fixture
		{
		
		    public function getDependencies()
		    {}
		
		    /**
		     *
		     * {@inheritdoc}
		     *
		     * @see \Doctrine\Common\DataFixtures\FixtureInterface::load()
		     */
		    public function load(ObjectManager $manager)//最主要的function
		    {
		        /**
		         *
		         * @var \MenuBundle\Repository\MenuRepository $repo
		         */
		        $repo = $manager->getRepository('MenuBundle:Menu');
		        $createAt = new \DateTime();
		        foreach ($this->getMenuList() as $val) {
		            $menu = $repo->findOneBy([
		                'node' => $val['node']
		            ]);
		            if (empty($menu)) {
		                $menu = new Menu();
		            }
		            $menu->setName($val['name']);
		            $menu->setEnglishName($val['english_name']);
		            $menu->setParentNode($val['parent_node']);
		            $menu->setLevel($val['level']);
		            $menu->setStatus($val['status']);
		            $menu->setActive($val['active']);
		            $menu->setNode($val['node']);
		            if (isset($val['icon'])) {
		                $menu->setIcon($val['icon']);
		            }
		            $menu->setCreateAt($createAt);
		            $menu->setUpdateAt($createAt);
		            $manager->persist($menu);
		            $manager->flush();
		        }
		    }
		
		    /**
		     * 系统管理后台
		     *
		     * @return string[][]|number[][]
		     */
		    private function getAdminMenu()
		    {
		        $parentNode = 10000;
		        $menu = [
		            [
		                'name' => '后台管理',
		                'english_name' => 'admin_homepage',
		                'parent_node' => $parentNode,
		                'level' => 2,
		                'status' => 1,
		                'active' => 1,
		                'node' => 10100
		            ] // 排序在父级的基础上增加
		        ]; 
		        return $menu;
		    }
		
		    /**
		     * 系统设置管理
		     *
		     * @return string[][]|number[][]
		     */
		    private function getSystemMenu()
		    {
		        $parentNode = 20000;
		        $menu = [
		            [
		                'name' => '权限设置',
		                'english_name' => 'rbac_role',
		                'parent_node' => $parentNode,
		                'level' => 2,
		                'status' => 1,
		                'active' => 1,
		                'node' => 20100
		            ],
				     return $menu;
		    }
		
		    /**
		     *
		     * @return string[]
		     */
		    private function getMenuList() //合并数组
		    {
		        // node 越小优先级越高， 大菜单的level=1，小菜单level=2，内页的顶部菜单level=3
		        $menu = [
		            [
		                'name' => '动物疫苗防控',
		                'english_name' => 'admin_homepage',
		                'parent_node' => 0,
		                'level' => 0,
		                'status' => 1,
		                'active' => 0,
		                'node' => 1
		            ],
		            [
		                'name' => '系统管理后台',
		                'english_name' => 'admin_homepage',
		                'parent_node' => 1,
		                'level' => 1,
		                'status' => 1,
		                'active' => 1,
		                'icon' => 'static/images/icon_xyrygl.png',
		                'node' => 10000
		            ]
		        ];
		        // 菜单合并
		        $arr = array_merge($menu, $this->getAdminMenu(), $this->getSystemMenu());
		        return $arr;
		    }
		}
		
		
- service 注册

		menu.menu_datafixtures:
	   	class: MenuBundle\DataFixtures\MenuFixtures
			tags: ['doctrine.fixture.orm'] //特别注意这个tags 必须如此填写	
	
