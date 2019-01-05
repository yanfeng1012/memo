## 设置账户名、邮箱

    git config --global user.name "XXX"

	git config --global user.email "XXX@163.com"

## 记住密码

### Https记住密码

- 永久记住密码
  
 		git config --global credential.helper store 

- 临时记住密码

	- 默认15分钟

			git config –global credential.helper cache

	- 自定义时间（1小时）

			git config credential.helper ‘cache –timeout=3600’

### SSH记住密码

- 可以从一个已有的SSH KEY来记住密码，会在用户主目录下的known_hosts生成配置。

	- 把ssh key添加到ssh-agent

			$ eval $(ssh-agent -s)
			$ ssh-add ~/.ssh/id_rsa

	- 添加过程：

			$ eval $(ssh-agent -s)
			Agent pid 54188
			
			$ ssh-add ~/.ssh/id_rsa
			Enter passphrase for /c/Users/Administrator/.ssh/id_rsa:
			Identity added: /c/Users/Administrator/.ssh/id_rsa (/c/Users/Administrator/.ssh/id_rsa)