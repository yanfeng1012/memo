## Eevent Listenser

1. 调试listenser

		$ php bin/console debug:container session
		
		  Information for Service "session"
		  =================================
		  
		   ------------------ --------------------------------------------------
		    Option             Value
		   ------------------ --------------------------------------------------
		    Service ID         session
		    Class              Symfony\Component\HttpFoundation\Session\Session
		    Tags               -
		    Public             yes
		    Synthetic          no
		    Lazy               no
		    Shared             yes
		    Abstract           no
		    Autowired          no
		    Autowiring Types   -
		   ------------------ --------------------------------------------------
		   
2. [Login Listener](/Inc/symfony/listenser/login.md)&nbsp;&nbsp;&nbsp;&nbsp;登陆事件监听
3. [Guzzle Event Listener](/Inc/symfony/listenser/guzzle.md)&nbsp;&nbsp;&nbsp;&nbsp;Guzzle事件监听
4. [Enable Filter Listener](/Inc/symfony/listenser/filter.md)&nbsp;&nbsp;&nbsp;&nbsp;sql过滤事件监听
5. [Doctrine Event Listeners and Subscribers](https://symfony.com/doc/3.4/doctrine/event_listeners_subscribers.html)Doctrine事件监听