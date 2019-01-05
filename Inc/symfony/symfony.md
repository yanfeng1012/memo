1. doctrine:fixtures:load --fixtures=路径 --append 添加文件（类似侧边导航）
       		
		路径一定要写全路径 自打开gitbash的文件夹开始（symfony 3.3）
		doctrine:fixtures:load --append (symfony 3.4  无需填写路径)

2. symfony 命令行

	- 创建Bundle
	
			generate：Bundle
	
	- 创建Controller	

			generate：controller

 	- 创建command

			generate:command

	- 创建数据库

			doctrine：database：create 

			(ps:多库链接 doctrine：database：create --connection=[数据库配置名称])

	- 删除数据库

			doctrine：database：drop --force

	- 创建Entity

			doctrine:generate:entity

	- 生成getteer和setter 方法

			doctrine：generate：entities

	- 生成/更新实体表

			doctrine：schema：update --force

			(ps:多库链接 doctrine：schema：update --force --em=[数据库配置名称])

	- 清除缓存
		
			cache:clear --env=dev/prod 

3. [Doctrine 关联映射](./mapping.md)
