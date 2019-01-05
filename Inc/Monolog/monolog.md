## monolog

### Installation

	composer require monolog/monolog
	
### Basic Usage

	<?php
	
	use Monolog\Logger;
	use Monolog\Handler\StreamHandler;
	
	// create a log channel
	$log = new Logger('name');
	$log->pushHandler(new StreamHandler('path/to/your.log', Logger::WARNING));
	
	// add records to the log
	$log->warning('Foo');
	$log->error('Bar');
	
### symfony 使用

- 修改symfony prod.log下日志信息 

		#app/config/config_prod.yml
		  monolog:
		      handlers:
		          main:
		              type: fingers_crossed
		              action_level: error
		              handler: nested
		          nested:
		              type: stream
		              path: '%kernel.logs_dir%/%kernel.environment%.log'
		              level: debug # 更改为error
		          console:
		              type: console
		              process_psr_3_messages: false
	              
- 简单的使用

		/**
		  * @var  \Psr\Log\LoggerInterface $logger
		  */
		$logger = $this->get('logger');
		$logger->alert('pay faild', $result); // $result is array
	
- 配置日志存放

		 monolog:
		      handlers:
		          # this "file_log" key could be anything
		          file_log:
		              type: stream
		              path: "%kernel.logs_dir%/%kernel.environment%_alert.log"
		              level: alert
	              
- 日志的分割  

		 #app/config/config_dev.yml
		  monolog:
		      handlers:
		          main:
		              type:  rotating_file
		              path:  '%kernel.logs_dir%/%kernel.environment%.log'
		              level: debug
		              # max number of log files to keep
		              # defaults to zero, which means infinite files
		              max_files: 10
	              
- 日志的错误级别

>The LoggerInterface exposes eight methods to write logs to the eight RFC 5424 levels (`debug`, `info`, `notice`, `warning`, `error`, `critical`, `alert`, `emergency`).