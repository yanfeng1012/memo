## 时间计算（闰年天数bug）

	/**
	 *
	 * 计算两个日期相隔多少年，多少月，多少天
	 *
	 * @param $date1 [格式如：2011-11-5]
	 * @param $date2 [格式如：2012-12-01]
	 * @return string
	 */
	public function diffDate($date1, $date2)
	{
	    // 法定期限规定
	    if (strtotime($date1) > strtotime($date2)) {
	        $tmp = $date2;
	        $date2 = $date1;
	        $date1 = $tmp;
	    }
	
	    list($Y1, $m1, $d1) = explode('-', $date1);
	    list($Y2, $m2, $d2) = explode('-', $date2);
	
	    $Y = $Y2 - $Y1;
	    $m = $m2 - $m1;
	    $d = $d2 - $d1;
	
	    if ($d < 0) {
	        $d += (int)date('t', strtotime("-1 month $date2"));
	        $m --;
	    }
	    if ($m < 0) {
	        $m += 12;
	        $Y --;
	    }
	
	    return (empty($Y) ? "" : $Y . '年') . (empty($m) ? "" : $m . '月') . (empty($d) ? "" : $d . '日');
	}