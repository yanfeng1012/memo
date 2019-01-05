## js打印

- js

		function printdiv(printpage) {
			var body = $("body").html();
			var headstr = "<html><head><title></title></head><body>";
			var footstr = "</body>";
			var num = $("#" + printpage);
			var tr_length = num.find("tr");
			for(var i = 0; i < tr_length.length; i++) {
				if(i == 0) {
					num.find("tr").eq(i).find("th").last().remove()
				} else {
					num.find("tr").eq(i).find("td").last().remove()
				}
			}
			var newstr = document.all.item(printpage).innerHTML;
			//								var oldstr = document.body.innerHTML;
			document.body.innerHTML = headstr + newstr + footstr;
			window.print();
			document.body.innerHTML = body;
			window.location.reload(true);
			return false;
		}
		function printdivxq(printpage,title) {
			var body = $("body").html();
			var headstr = "<html><head><title></title></head><body>";
			var stylestr="<style>input{border:0px;}.table tr th,.table tr td{text-align: center;}.table button.zc{padding: 2px 8px;background-color: #f1f2f8;color: #94add5;}.table button.yc{padding: 2px 8px;background-color: #fdefe1;color: #f49a43;}.Title_print{text-align: center;}.Title_print,.table{margin-top:30px;}</style>";
			var title_h3 = "<h3 class='Title_print'>"+title+"</h3>";
			var footstr = "</body>";
			var num = $("#" + printpage);
			var tr_length = num.find(".budaying");
			for(var i = 0; i < tr_length.length; i++) {
					num.find(".budaying").eq(0).remove()
			}
			var newstr = document.getElementById(printpage).innerHTML;
			//var oldstr = document.body.innerHTML;
			document.body.innerHTML = headstr+stylestr + title_h3 + newstr + footstr;
			window.print();
			document.body.innerHTML = body;
			window.location.reload(true);
			return false;
		}
		function print_new_table(printpage,title) {
			var body = $("body").html();
			var headstr = "<html><head><title></title></head><body>";
			var stylestr="<style>.table_box {width: 90%;margin: 50px auto;color: #333333;}.table_box input {border: 0px solid;border-bottom: 1px solid #333;width: 40px;text-align: center;}.table_box textarea {border: 0px solid;text-align: left;width: 100%;height: 320px;line-height: 40px;resize: none;text-indent: 2em;background: transparent;/*text-decoration: underline;*/}.table_box .indet{text-indent: 2em;}.ta_c {text-align: center;}.ta_l {text-align: left;}.ta_r {text-align: right;}.table tr td{text-align: center;vertical-align: middle;border-color:#333333;}.table tr td input.ta_l{text-align: left;}.table tr td input.ta_r{text-align: right;}.table input{border: 0px;width: 100%;text-align: center;height: 32px;}.table-bordered textarea {height:100px;}</style>";
			var title_h3 = "<h3 class='Title_print'>"+title+"</h3><div class='table_box'>";
			var footstr = "</div></body>";
			var num = $("#" + printpage);
			var tr_length = num.find(".budaying");
			for(var i = 0; i < tr_length.length; i++) {
					num.find(".budaying").eq(0).remove()
			}
			var newstr = document.getElementById(printpage).innerHTML;
		
			//var oldstr = document.body.innerHTML;
			document.body.innerHTML = headstr+stylestr + title_h3 + newstr + footstr;
			console.log(document.body.innerHTML);
			window.print();
			document.body.innerHTML = body;
			window.location.reload(true);
			return false;
		}

- 点击事件

		onclick="print_new_table('Printing_box',' ')；//Printing_box 为打印区域的id
		<div class="table-responsive" style="width: 800px;margin: 0 auto;" id="Printing_box"></div>