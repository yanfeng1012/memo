## 文件上传配置

- 修改 ueditor.config.js

		// 服务器统一请求接口路径
		serverUrl: window.UEDITOR_SERVER_URL
		window.UEDITOR_SERVER_URL 为自定义上传路径
		
- 实例化ueditor

	   	window.UEDITOR_SERVER_URL = "adjust.com/admin/base/upload/ueditor"; // 文件上传统一路径
	   	var um = UE.getEditor('editor');// 实例化
		
- ueditor编辑器上传处理

		/**
		 * ueditor编辑器上传处理
		 *
		 * @return \Symfony\Component\HttpFoundation\JsonResponse array(
		 *         "state" => "", //上传状态，上传成功时必须返回"SUCCESS"
		 *         "url" => "", //返回的地址
		 *         "title" => "", //新文件名
		 *         "original" => "", //原始文件名
		 *         "type" => "" //文件类型
		 *         "size" => "", //文件大小
		 *         )
		 */
		public function ueditorAction(Request $request)
		{
		    $action = $request->query->get('action');
		
		    switch ($action) {
		        case 'config':
		            // 获取ueditor配置
		            $projectDir = $this->get('kernel')->getProjectDir();
		            $result = json_decode(preg_replace("/\/\*[\s\S]+?\*\//", "", file_get_contents($projectDir . "/web/public/ueditor/php/config.json")), true);
		            break;
		        case 'uploadimage':
		        // 上传图片
		        case 'uploadscrawl':
		        // 上传涂鸦
		        case 'uploadvideo':
		        // 上传视频
		        case 'uploadfile':
		            // 上传文件
		            $result = $this->handleUpload($request, $action);
		            break;
		        case 'listimage':
		            // 列出图片
		            $result = $this->listImage($request);
		            break;
		        case 'listfile':
		            // 列出文件
		            $result = $this->listFile($request);
		            break;
		        case 'catchimage':
		            // 抓取远程文件
		            $result = $this->crawlerImage($request);
		            break;
		
		        default:
		            $result = [
		                'state' => '请求地址出错'
		            ];
		            break;
		    }
		    return $this->json($result);
		}
		
		/**
		 * ueditor编辑器处理图片上传
		 *
		 * @param Request $request
		 * @return string[]
		 */
		private function handleUpload(Request $request, $action)
		{
		    $file = $request->files->get('upfile');
		    if ($file instanceof UploadedFile) {
		        $originalName = $file->getClientOriginalName();
		        $size = $file->getSize();
		        $type = $file->guessClientExtension();
		        /**
		         *
		         * @var \BaseBundle\Service\UploadFileService $uploadService
		         */
		        $uploadService = $this->get('base.upload_file_service');
		        $mimeTypes = $this->getMimeType($action);
		        $result = $uploadService->run($file, $mimeTypes, 'ueditor');
		        if ($result['code'] == 1 && isset($result['data'])) {
		            return [
		                "state" => "SUCCESS", // 上传状态，上传成功时必须返回"SUCCESS"
		                "url" => 'http://' . $request->getHost() . '/' . $result['data'], // 返回的地址
		                "title" => $originalName, // 新文件名
		                "original" => $originalName, // 原始文件名
		                "type" => $size, // 文件类型
		                "size" => $type // 文件大小
		            ];
		        } else {
		            return [
		                'state' => $result['msg'],
		                'data' => $result
		            ];
		        }
		    }
		    return [
		        'state' => '未上传文件'
		    ];
		}
		
		/**
		 *
		 * @param unknown $action
		 * @return boolean|string[]
		 */
		private function getMimeType($action)
		{
		    $mimeTypes = [
		        'uploadimage' => [
		            'image/gif',
		            'image/jpeg',
		            'image/pjpeg',
		            'image/png',
		            'image/bmp'
		        ],
		        'uploadscrawl' => [
		            'image/gif',
		            'image/jpeg',
		            'image/pjpeg',
		            'image/png',
		            'image/bmp'
		        ],
		        'uploadvideo' => [
		            'audio/mpeg',
		            'audio/x-wav',
		            "video/dl",
		            "video/fli",
		            "video/gl",
		            "video/mpeg",
		            "video/quicktime",
		            "video/x-ms-asf",
		            "video/x-msvideo",
		            "video/x-sgi-movie",
		            "video/mp4"
		        ],
		        'uploadfile' => [
		            'application/msword',
		            'application/pdf',
		            'application/vnd.ms-excel',
		            'application/vnd.ms-powerpoint',
		            'application/vnd.ms-works',
		            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
		            'application/octet-stream',
		            'text/plain',
		            'text/html',
		            'application/x-gzip',
		            'application/x-gtar',
		            'application/zip'
		        ]
		    ];
		    return isset($mimeTypes[$action]) ? $mimeTypes[$action] : false;
		}
		
		/**
		 * ueditor编辑器，列出图片
		 *
		 * @param Request $request
		 * @return string[]
		 */
		private function listImage(Request $request)
		{}
		
		/**
		 * ueditor编辑器，列出文件
		 *
		 * @param Request $request
		 * @return string[]
		 */
		private function listFile(Request $request)
		{}
		
		/**
		 * ueditor编辑器，远程抓取图片
		 *
		 * @param Request $request
		 * @return string[]
		 */
		private function crawlerImage(Request $request)
		{}	