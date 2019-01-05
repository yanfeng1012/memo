## app 版本更新下载

- 基于symfony 的APP版本控制(更新&&下载)

		class VersionController extends BaseController
		{
		
		    /**
		     * 检查版本更新
		     *
		     * @param Request $request
		     * @return \Symfony\Component\HttpFoundation\JsonResponse
		     */
		    public function checkVersionAction(Request $request)
		    {
		        $versionnum = $request->request->get('versionnum');
		
		        /**
		         *
		         * @var \SystemBundle\Repository\VersionRepository $verRepo
		         */
		        $newVersion = $this->getDoctrine()
		            ->getRepository('SystemBundle:Version')
		            ->getNewest();
	            $nowV = explode('.', $versionnum);
        		  $hVersion = explode('.', $newVersion['versionnum']);
		        if (! empty($newVersion)) {
		            if ($nowV[0] < $hVersion[0] || $nowV[1] < $hVersion[1] || $nowV[2] < $hVersion[2]) {
		                return $this->json([
		                    'code' => 1,
		                    'msg' => '成功',
		                    'data' => $newVersion,
		                    'status' => 1,
		                    'url' => "http://" . $request->getHost() . '/' . $newVersion['url']
		                ]);
		            } else {
		                return $this->json([
		                    'code' => 1,
		                    'msg' => '已是最新版本',
		                    'status' => 2
		                ]);
		            }
		        } else {
		            return $this->json([
		                'code' => 1,
		                'msg' => '未发现新版本',
		                'status' => 3
		            ]);
		        }
		    }
		
		    /**
		     * 版本更新下载
		     *
		     * @param Request $request
		     * @return \Symfony\Component\HttpFoundation\JsonResponse
		     */
		    public function downloadAction(Request $request)
		    {
		        $versionnum = $request->request->get('versionnum');
		        if (empty($versionnum)) {
		            return $this->json([
		                'code' => 500,
		                'msg' => '版本号为空'
		            ]);
		        }
		        $version = $this->getDoctrine()
		            ->getRepository('SystemBundle:Version')
		            ->findOneBy([
		            'versionnum' => $versionnum
		        ]);
		        if (empty($version)) {
		            return $this->json([
		                'code' => '2',
		                'msg' => '未找到该版本文件'
		            ]);
		        }
		        $apkName = '自定义APP名 ' . $versionnum;
		        $apkPath = $this->getParameter('kernel.root_dir') . '/../web/' . $version->getUrl();//下载文件路径
		        if (! file_exists($apkPath)) {
		            return $this->json([
		                'code' => 500,
		                'msg' => '下载文件不存在'
		            ]);
		        }
		        $this->file($apkPath, $apkName, ResponseHeaderBag::DISPOSITION_INLINE);//文件下载
		        return $this->json([
		            'code' => 1,
		            'msg' => '成功'
		        ]);
		    }
		}
		
		?>
