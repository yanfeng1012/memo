## 自定义函数

### date_format

	CREATE OR REPLACE FUNCTION date_format(indate anyelement, intext text)
	 	RETURNS text LANGUAGE sql AS $function$
	BEGIN
		IF upper(inText) = upper('%Y%m%d_%H%i') THEN
			return to_char(inDate,'YYYYMMDD_HH24MI');
		END IF;
		IF upper(inText) = upper('%Y%m%d%H%i%s') THEN
			return to_char(inDate,'YYYYMMDDHH24MISS');
		END IF;
		IF upper(inText) = upper('%Y-%m-%d %H') THEN
			return to_char(inDate,'YYYY-MM-DD HH24');
		END IF;
		IF upper(inText) = upper('%Y-%m-%d') THEN
			return to_char(inDate,'YYYY-MM-DD');
		END IF;
		IF upper(inText) = upper('%Y-%m') THEN
			return to_char(inDate,'YYYY-MM');
		end if;
		IF upper(inText) = upper('%m%d') THEN
		return to_char(inDate,'MMDD');
		END IF;
		return '';
	END;
	$function$
		



	
