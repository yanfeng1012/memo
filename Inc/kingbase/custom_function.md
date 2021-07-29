## 自定义函数

### group by 
	修改kingbase.conf 增加
	sql_mode=''

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
	
### `find_in_set`

	CREATE OR REPLACE INTERNAL FUNCTION PUBLIC.FIND_IN_SET( CHARACTER VARYING, CHARACTER VARYING ) 
		RETURNS CHARACTER VARYING LANGUAGE PLSQL IMMUTABLE STRICT AS $FUNCTION$ 
	DECLARE
		tokens VARCHAR [];
	BEGIN
		tokens := sys_catalog.string_to_array ( $2, ',' );
		RETURN ISNULL( sys_catalog.array_position ( tokens, $1 ), 0 )> 0;
	END;
	$FUNCTION$;


### UNIX_TIMESTAMP

	CREATE FUNCTION unix_timestamp() 
		RETURNS integer AS $$
		SELECT (date_part('epoch',now()))::integer;
	$$ LANGUAGE SQL IMMUTABLE;
	
### from_unixtime()

	CREATE FUNCTION from_unixtime(int) 
		RETURNS timestamp AS $$
		SELECT to_timestamp($1)::timestamp;
	$$ LANGUAGE SQL IMMUTABLE;
	
### from_unixtime()

	CREATE OR REPLACE FUNCTION date_format(indate anyelement, intext text)
	 	RETURNS text LANGUAGE sql AS $function$		BEGIN			IF upper(inText) = upper('%Y%m%d_%H%i') THEN				return to_char(to_timestamp(inInt)::timestamp,'YYYYMMDD_HH24MI');			END IF;			IF upper(inText) = upper('%Y%m%d%H%i%s') THEN				return to_char(to_timestamp(inInt)::timestamp,'YYYYMMDDHH24MISS');			END IF;			IF upper(inText) = upper('%Y-%m-%d %H') THEN				return to_char(to_timestamp(inInt)::timestamp,'YYYY-MM-DD HH24');			END IF;			IF upper(inText) = upper('%Y-%m-%d') THEN				return to_char(to_timestamp(inInt)::timestamp,'YYYY-MM-DD');			END IF;			IF upper(inText) = upper('%Y-%m') THEN				return to_char(to_timestamp(inInt)::timestamp,'YYYY-MM');			END IF;			IF upper(inText) = upper('%m%d') THEN				return to_char(to_timestamp(inInt)::timestamp,'MMDD');			END IF;			return '';		END
		$function$
	
