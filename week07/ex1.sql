-- 1NF: relation already in 1NF, since there is no duplicated tuples, no repeating groups and columns are atomic

-- 2NF:
-- Order: order_id, date, customer_id
-- OrderItem: ord_id, order_id, item_id, quant
-- Customer: customer_id, customer_name, city
-- Item: item_id, item_name, price

-- 3NF:

CREATE TABLE IF NOT EXISTS public."Item"
(
    item_id integer NOT NULL,
    item_name character(255),
    price integer,
    PRIMARY KEY (item_id)
);

ALTER TABLE public."Item"
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public."City"
(
    city_id integer NOT NULL,
    city_name character(255),
    PRIMARY KEY (city_id)
);

ALTER TABLE public."City"
    OWNER to postgres;
	
CREATE TABLE IF NOT EXISTS public."Customer"
(
    customer_id integer NOT NULL,
    customer_name character(255),
	city_id integer,
    FOREIGN KEY (city_id) REFERENCES "City"(city_id),
    PRIMARY KEY (customer_id)
);

ALTER TABLE public."Customer"
    OWNER to postgres;
	
CREATE TABLE IF NOT EXISTS public."Order"
(
    order_id integer NOT NULL,
    date date,
	customer_id integer,
    FOREIGN KEY (customer_id) REFERENCES "Customer"(customer_id),
    PRIMARY KEY (order_id)
);

ALTER TABLE public."Order"
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public."OrderItem"
(
    ord_id integer NOT NULL,
	order_id integer,
    FOREIGN KEY (order_id) REFERENCES "Order"(order_id),
	item_id integer,
    FOREIGN KEY (item_id) REFERENCES "Item"(item_id),
    quant integer,
    PRIMARY KEY (ord_id)
);

ALTER TABLE public."OrderItem"
    OWNER to postgres;

-- Calculate the total number of items per order and the total amount to pay for the order.
SELECT order_id, sum(quant) as items_quant, sum(quant*price) as total_cost
FROM (
	SELECT * 
	FROM "OrderItem" as oi
	INNER JOIN "Item" as i
	ON oi.item_id = i.item_id
) as x
GROUP BY order_id

-- Obtain the customer whose purchase in terms of money has been greater than the others
SELECT *
FROM (
	SELECT customer_id, SUM(quant * price) as purchase_cost
	FROM (
		SELECT *
		FROM (
			SELECT * 
			FROM "OrderItem" as oi
			INNER JOIN "Item" as i
			ON oi.item_id = i.item_id
		) as x
		INNER JOIN "Order" as i1
		ON x.order_id = i1.order_id
	) as x1
	GROUP BY customer_id
) as x2
ORDER BY purchase_cost DESC
LIMIT 1

