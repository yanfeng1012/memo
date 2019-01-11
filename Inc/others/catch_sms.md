## 发送短信验证码验证

- 基于symfony 的发送短信验证码验证

		/**
	     * 发送验证码
	     *
	     * @param Request $request
	     * @return \Symfony\Component\HttpFoundation\Response
	     */
	    public function smscodeAction(Request $request)
	    {
	        $mobile = $request->request->get('mobile');
	        $captcha = $request->request->get('captcha');
	        if (empty($captcha)) {
	            return $this->json([
	                'code' => 502,
	                'msg' => '验证码不能为空'
	            ]);
	        }
	        $session = new Session();
	        $captchaArr = $session->get('login');
	        $captchaSession = $captchaArr['phrase'];
	        if ($captchaSession != $captcha) {
	            return $this->json([
	                'code' => 503,
	                'msg' => '验证码错误'
	            ]);
	        }
	        if (md5($captcha) == $request->cookies->get('captcha')) {
	            return $this->json([
	                'code' => 700,
	                'msg' => '验证码已过期'
	            ]);
	        }
	        if (! $this->isMobile($mobile)) {
	            return $this->json([
	                'code' => 501,
	                'msg' => '手机号码格式错误'
	            ]);
	        }
	        /**
	         *
	         * @var \RbacBundle\Repository\UserRepository $uRepo
	         */
	        $uRepo = $this->getDoctrine()->getRepository('RbacBundle:User');
	        /**
	         *
	         * @var \RbacBundle\Entity\User $user
	         */
	        $user = $uRepo->findOneBy([
	            'phone' => $mobile
	        ]);
	        if (empty($user)) {
	            return $this->json([
	                'code' => 101,
	                'msg' => '该用户不存在'
	            ]);
	        }
	        if ($request->cookies->get('mobile') == md5($mobile)) {
	            return $this->json([
	                'code' => 504,
	                'msg' => '短信已发送，重新获取请间隔60S'
	            ]);
	        }
	        /**
	         *
	         * @var \BaseBundle\Service\SmsService $smsService
	         */
	        $smsService = $this->get('base.sms_service');
	        $result = $smsService->request($mobile, 'forget');
	        if ($result['code'] == 1 && isset($result['data']['code'])) {
	            $response = $this->json([
	                'code' => 1,
	                'msg' => '发送成功',
	                'data' => $mobile . '_wateroa_' . $result['data']['code']
	            ]);
	            $response->headers->setCookie(new Cookie('captcha', md5($captcha), time() + 600));
	            $response->headers->setCookie(new Cookie('mobile', md5($mobile), time() + 60));
	            $response->headers->setCookie(new Cookie('hash', md5($mobile . '特殊字段' . $result['data']['code']), time() + 60));
	            return $response;
	        } else {
	            return $this->json([
	                'code' => 503,
	                'msg' => '短信发送失败',
	                'data' => $result
	            ]);
	        }
	    }
	
	    /**
	     * * 判断是否是手机号
	     */
	    private function isMobile($mobile)
	    {
	        return preg_match('#^13[\d]{9}$|^14[5,7]{1}\d{8}$|^15[^4]{1}\d{8}$|^17[0,6,7,8]{1}\d{8}$|^18[\d]{9}$#', $mobile);
	    }
