CREATE OR REPLACE FUNCTION paging(row_from int, row_to int)
RETURNS SETOF customer
LANGUAGE plpgsql
AS $$
DECLARE
  r customer%rowtype;
BEGIN
  IF row_from > row_to THEN 
  	RAISE EXCEPTION 'row_from should be <= row_to';
  END IF;
  IF row_from < 1 THEN 
  	RAISE EXCEPTION 'row_from should be >= 1';
  END IF;
  IF row_to > 599 THEN 
  	RAISE EXCEPTION 'row_to should be <= 599';
  END IF;
  
  FOR r IN
  	SELECT customer.*
	FROM customer
	ORDER BY customer.address_id
	OFFSET row_from - 1
	LIMIT row_to - row_from + 1
  LOOP
  	RETURN NEXT r;
  END LOOP;
  RETURN;
END;
$$;
