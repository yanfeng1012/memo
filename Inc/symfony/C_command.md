## 自定义command

	<?php
	
	namespace ApiBundle\Command;
	
	use Symfony\Bundle\FrameworkBundle\Command\ContainerAwareCommand;
	use Symfony\Component\Console\Input\InputInterface;
	use Symfony\Component\Console\Input\InputOption;
	use Symfony\Component\Console\Output\OutputInterface;
	
	class PullCommandCommand extends ContainerAwareCommand
	{
		//定义命令方式
	    protected function configure()
	    {
	        $this->setName('api:pull:information')
	            ->addOption('type', 't', InputOption::VALUE_REQUIRED, 'Please enter typeid')//addoption 是使用--type=** 来传递参数  addagrement 是在命令后面输入参数
	            ->setDescription('pull information ...')
	            ->setHelp("This command allows pull information from the department of justice...")
	        ;
	    }
	
		//命令执行逻辑
	    protected function execute(InputInterface $input, OutputInterface $output)
	    {
	        $type = $input->getOption('type');
	        ......

				逻辑处理

			......
	        $this->apiRequest($type,$output);
	        $output->writeln();
	    }
	
		//自定义处理方法
	    private function apiRequest($type, OutputInterface $output)
	    {
	        $data = array();
	        $api = $this->getContainer()->get('api.request_service');
	        $result = $api->run($type,$data);
	        $result = json_encode($result);
	        $output->writeln($result['code']);
	    }
	
	}
