## call_back

- 子页面

		parent.window.call_back(user_id,user_name,work_time,date);

- 父页面

		window.call_back = function(user_id,user_name,work_time,date){
			var _day = $(_self).parents('.bg-white').find('span').eq(0).text();
			var _str = "<span>"+_day+"</span>"+
				"<span class='right' onclick='trigger(this)' date-value="+date+">"+
					"<img src='{{ asset('img/bj.png'|theme) }}' alt='' / style=''>"+
					"</span>"+
					"<div class='area' >"+
					"<div class='name'>"+
						"<div>"+user_name+"</div>"+
						"<input type='hidden' name='Scheduling[user_id][]' id='' value="+user_id+" />"+
						"<input type='hidden' name='Scheduling[user_name][]' id='' value="+user_name+" />"+
						"<input type='hidden' name='Scheduling[date][]' id='' value="+date+" />"+
						"<input type='hidden' name='Scheduling[institution_id][]' id='' value='{{ authenast.id }}' />"+
						"<input type='hidden' name='Scheduling[institution_name][]' id='' value='{{ authenast.name }}' />"+
						"<input type='hidden' name='Scheduling[work_time][]' id='' value="+work_time+" />"+
						"<div>"+work_time+"</div>"+
					"</div>"+
						"</div>";
			$(_self).parents('.bg-white').html(_str);
		}
