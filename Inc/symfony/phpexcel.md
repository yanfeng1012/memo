## symfony 使用第三方bundle导出简单excel表格

- 第一步：
 
		$composer require liuggio/excelbundle

- 第二步：执行composer更新。

		composer update

- 第三步：添加bundle在app/AppKernel.php

		$bundles = array(
	        // ...
	        new Liuggio\ExcelBundle\LiuggioExcelBundle(),
	    );

- 第四步：编写对应的action（）

		$phpExcelObject = $this->get(‘phpexcel’)->createPHPExcelObject();//访问excel服务
		
		$phpExcelObject->getProperties()->setCreator(“liuggio”)//设置创建人
		
		->setLastModifiedBy(“Giulio De Donato”)//设置最后修改人
		
		->setTitle(“Office 2005 XLSX Test Document”)//设置标题
		
		->setSubject(“Office 2005 XLSX Test Document”)//设置题目
		
		->setDescription(“Test document for Office 2005 XLSX, generated using PHP classes.”)//设置描述
		
		->setKeywords(“office 2005 openxml php”)//设置关键字
		
		->setCategory(“Test result file”);//设置种类
		
		$phpExcelObject->getActiveSheet()->setTitle(‘Simple’);//设置sheet的名称
		
		$phpExcelObject->setActiveSheetIndex(0);//设置当前sheet
		
		$phpExcelObject->getActiveSheet()->setCellValue(‘The cell name’,’content’);//设置单元格名称
		
		// create the writer
		
		$writer = $this->get(‘phpexcel’)->createWriter($phpExcelObject, ‘Excel5’);
		
		// create the response
		
		$response = $this->get(‘phpexcel’)->createStreamedResponse($writer);
		
		// adding headers
		
		$dispositionHeader = $response->headers->makeDisposition(
		
			ResponseHeaderBag::DISPOSITION_ATTACHMENT,
			
			‘stream-file.xls’
		
		);
		
		$response->headers->set(‘Content-Type’, ‘text/vnd.ms-excel; charset=utf-8’);
		
		$response->headers->set(‘Pragma’, ‘public’);
		
		$response->headers->set(‘Cache-Control’, ‘maxage=1’);
		
		$response->headers->set(‘Content-Disposition’, $dispositionHeader);
		
		return $response;