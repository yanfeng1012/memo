## Enable Filter Listener

- 定义EnableFilterListener

		  namespace BaseBundle\EventListener;
		
		  use Doctrine\ORM\EntityManager;
		  use Symfony\Component\Security\Core\Authentication\Token\Storage\TokenStorageInterface;
		  use RbacBundle\Entity\User;
		
		  class EnableFilterListener
		  {
		      protected $em;
		      protected $tokenStorage;
		      protected $reader;
		
		      public function __construct(EntityManager $em, TokenStorageInterface $tokenStorage)
		      {
		          $this->em              = $em;
		          $this->tokenStorage    = $tokenStorage;
		      }
		
		      public function onKernelRequest()
		      {
		          $token = $this->tokenStorage->getToken();
		
		          if (!$token) {
		              return false;
		          }
		          $user = $token->getUser();
		          if ($user instanceof User) {
		              $filters = $this->em->getFilters()->enable('base.level_filter');
		              $filters->setParameter('filedName', 'username');
		              $filters->setParameter('filedValue', $user->getUsername());
		
		          }else{
		              return false;
		          }
		          return true;
		      }
	  	}
	  	
- 配置

	- service:
	
			  base.enable_filter_listener:
			      class: BaseBundle\EventListener\EnableFilterListener
			      arguments: ["@doctrine.orm.entity_manager", "@security.token_storage"]
			      tags:
			          - { name: kernel.event_listener, event: kernel.request, method: onKernelRequest}

	- config:

			orm:
		        auto_generate_proxy_classes: '%kernel.debug%'
		        default_entity_manager: default
		        entity_managers:
		            default:
		                connection: default
		                naming_strategy: base.capital_naming_strategy
		                filters: //定义filters
		                    base.level_filter: BaseBundle\Doctrine\Filter\LevelFilter
		                auto_mapping: true
				
	- ps: Repository中的query Function 必须为DQL
