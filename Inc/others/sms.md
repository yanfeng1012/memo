## 简单的短信发送

- service class

		namespace BaseBundle\Service;
		
		use Doctrine\ORM\EntityManager;
		use Symfony\Component\DependencyInjection\Container;
		use GuzzleHttp\Exception\ClientException;
		use GuzzleHttp\Exception\RequestException;
		use MessageBundle\Entity\MsmSending;
		
		class SmsService
		{
		
		    private $em;

	    private $container;
	
	    /**
	     *
	     * @var \Doctrine\Bundle\DoctrineBundle\Registry
	     */
	    private $doctrine;
	
	    public function __construct(EntityManager $em, Container $container)
	    {
	        $this->em = $em;
	        $this->container = $container;
	        $this->doctrine = $this->container->get('doctrine');
	    }
	
	    /**
	     *
	     * @param string $mobile
	     * @param string $ip
	     * @return boolean
	     */
	    public function addSms($mobile, $ip = '', $content = '', $fSR, $signature)
	    {
	        $mobile = is_array($mobile) ? implode(',', $mobile) : $mobile;
	        if (false !== strpos($mobile, ',')) {
	            $saveData = $this->saveData($mobile, $ip, $content, $fSR, $signature);
	            if (false == $saveData)
	                return false;
	            return $saveData;
	        } else {
	            if (false === $content)
	                return false;
	            $MsmSending = new MsmSending();
	            $MsmSending->setDHHM($mobile);
	            $MsmSending->setDXNR($signature . $content);
	            $MsmSending->setIP($ip);
	            $MsmSending->setFSZT('1');
	            $MsmSending->setFSR($fSR);
	            $this->em->persist($MsmSending);
	            $this->em->flush();
	            return true;
	        }
	    }
	
	    private function saveData($mobile, $ip, $content = '', $fSR, $signature)
	    {
	        if (false === $content)
	            return false;
	        $mobile = explode(',', $mobile);
	        foreach ($mobile as $vo) {
	            $MsmSending = new MsmSending();
	            $MsmSending->setDHHM($vo);
	            $MsmSending->setDXNR($signature . $content);
	            $MsmSending->setIP($ip);
	            $MsmSending->setFSZT('1');
	            $MsmSending->setFSR($fSR);
	            $this->em->persist($MsmSending);
	        }
	        $this->em->flush();
	        return true;
	    }
	
	    /**
	     *
	     * @return unknown[]|number[]
	     */
	    public function sendSms()
	    {
	        // 获取最新的20条记录
	        $list = $this->em->getRepository('MessageBundle:MsmSending')->findBy([
	            'fSZT' => 0
	        ], [
	            'id' => 'ASC'
	        ], 20);
	        $success = $faild = 0;
	        /**
	         *
	         * @var \MessageBundle\Entity\MsmSending $val
	         */
	        foreach ($list as $val) {
	            $response = $this->request(0, $val, 0, 0);
	            if (1 == $response['code']) {
	                $val->setFSZT(1);
	                $success ++;
	            } else {
	                $val->setFSZT(2);
	                $faild ++;
	            }
	            $val->setResponse(json_encode($response['data']));
	            $this->em->persist($val);
	            $this->em->flush();
	            sleep(1);
	        }
	        return [
	            'success' => $success,
	            'faild' => $faild
	        ];
	    }
	
	    /**
	     * 发起请求
	     */
	    public function request($mobile, $sms = '', $dXNR = '', $type = '')
	    {
	        $client = $this->getClient();
	        try {
	            if ($sms instanceof MsmSending) {
	                $params = $this->getParams($sms);
	            } else {
	                if (false !== $params = $this->getRequestParam($mobile, $dXNR, $type)) {
	                    $params = $this->getRequestParam($mobile, $dXNR, $type);
	                } else {
	                    return [
	                        'code' => 8,
	                        'msg' => 'faild 参数有误',
	                        'data' => ''
	                    ];
	                }
	            }
	            $response = $client->post($params['uri'], [
	                'form_params' => $params['data']
	            ]);
	            if (200 == $response->getStatusCode()) {
	                $content = (string) $response->getBody();
	                if (false !== strpos($content, ',')) {
	                    $result = explode(',', $content);
	                    if ('03' == $result[0] || '00' == $result[0]) {
	                        return [
	                            'code' => 1,
	                            'msg' => 'success',
	                            'data' => ''
	                        ];
	                    } else {
	                        return [
	                            'code' => 2,
	                            'msg' => 'faild',
	                            'data' => $content
	                        ];
	                    }
	                } else {
	                    return [
	                        'code' => 3,
	                        'msg' => 'response error',
	                        'data' => $content
	                    ];
	                }
	                return $content;
	            } else {
	                return [
	                    'code' => 4,
	                    'msg' => 'http error',
	                    'data' => [
	                        'exception_code' => $response->getStatusCode(),
	                        'exception_msg' => 'http code',
	                        'request' => '',
	                        'response' => $response->getBody()->getContents()
	                    ]
	                ];
	            }
	        } catch (ClientException $e) {
	            return [
	                'code' => 5,
	                'msg' => 'clint exception',
	                'data' => [
	                    'exception_code' => $e->getCode(),
	                    'exception_msg' => $e->getMessage(),
	                    'request' => $e->getRequest(),
	                    'response' => $e->getResponse()
	                ]
	            ];
	        } catch (RequestException $e) {
	            return [
	                'code' => 6,
	                'msg' => 'request exception',
	                'data' => [
	                    'exception_code' => $e->getCode(),
	                    'exception_msg' => $e->getMessage(),
	                    'request' => $e->getRequest(),
	                    'response' => $e->getResponse()
	                ]
	            ];
	        } catch (\Exception $e) {
	            return [
	                'code' => 7,
	                'msg' => 'exception',
	                'data' => [
	                    'exception_code' => $e->getCode(),
	                    'exception_msg' => $e->getMessage(),
	                    'request' => $e->getFile(),
	                    'response' => $e->getLine()
	                ]
	            ];
	        }
	    }
	
	    /**
	     * get guzzle http client
	     *
	     * @return \GuzzleHttp\Client
	     */
	    private function getClient()
	    {
	        return $this->container->get('eight_points_guzzle.client.api_sms');
	    }
	
	    private function getRequestParam($mobile, $dXNR = '', $type, $code = "")
	    {
	        switch ($type) {
	            case 'register':
	                $msg = '【山西司法社区矫正系统】欢迎注册山西司法社区矫正系统系统，验证码:' . $code . '';
	                break;
	            case 'forget':
	                $msg = '【山西司法社区矫正系统】您正在找回密码，验证码:' . $code . '';
	                break;
	            case 'sms':
	                $msg = "【山西司法社区矫正系统】通知您:";
	                break;
	            default:
	                return false;
	                break;
	        }
	
	        return [
	            'uri' => '/SendMT/SendMessage',
	            'data' => [
	                'CorpID' => 'jicheng',
	                'Pwd' => 'hcelbe',
	                'Mobile' => is_array($mobile) ? implode(',', $mobile) : $mobile,
	                'Content' => $msg . $dXNR
	            ]
	        ];
	    }
	
	    private function getParams(MsmSending $sms)
	    {
	        return [
	            'uri' => '/SendMT/SendMessage',
	            'data' => [
	                'CorpID' => '***',
	                'Pwd' => '****',
	                'Mobile' => $sms->getDHHM(),
	                'Content' => $sms->getDXNR()
	            ]
	        ];
	    }

- config.yml

		eight_points_guzzle:
		    # (de)activate logging/profiler; default: %kernel.debug%
		    logging: true
		    clients:
		        api_sms:
		            base_url: "http://101.200.29.88:8082"
		            options:
		                headers:
		                    Accept: "application/json"
		                    timeout: 30

- service.yml

		base.sms_service:
		        class: BaseBundle\Service\SmsService
		        arguments: ["@doctrine.orm.entity_manager","@service_container"]
