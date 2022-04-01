-- Table: public.Suppliers

-- DROP TABLE public."Suppliers";

CREATE TABLE IF NOT EXISTS public."Suppliers"
(
    sid integer NOT NULL,
    sname text COLLATE pg_catalog."default",
    address text COLLATE pg_catalog."default",
    CONSTRAINT "Suppliers_pkey" PRIMARY KEY (sid)
)

TABLESPACE pg_default;

ALTER TABLE public."Suppliers"
    OWNER to postgres;

-- Table: public.Parts

-- DROP TABLE public."Parts";

CREATE TABLE IF NOT EXISTS public."Parts"
(
    pid integer NOT NULL,
    pname text COLLATE pg_catalog."default",
    color text COLLATE pg_catalog."default",
    CONSTRAINT "Parts_pkey" PRIMARY KEY (pid)
)

TABLESPACE pg_default;

ALTER TABLE public."Parts"
    OWNER to postgres;

-- Table: public.Catalog

-- DROP TABLE public."Catalog";

CREATE TABLE IF NOT EXISTS public."Catalog"
(
    sid integer NOT NULL,
    pid integer NOT NULL,
    cost real,
    CONSTRAINT "Catalog_pkey" PRIMARY KEY (sid, pid)
)

TABLESPACE pg_default;

ALTER TABLE public."Catalog"
    OWNER to postgres;

-- Find the names of suppliers who supply some red part.
SELECT DISTINCT S.sname
FROM "Suppliers" as S, "Parts" as P, "Catalog" as C
WHERE S.sid=C.sid AND C.pid=P.pid AND P.color='Red';

-- Find the sids of suppliers who supply some red or green part.
SELECT DISTINCT sid
FROM "Parts" as P, "Catalog" as C
WHERE C.pid=P.pid AND (P.color='Red' OR P.color='Green');

-- Find the sids of suppliers who supply some red part or are at 221 Packer Street.
SELECT DISTINCT S.sid
FROM "Suppliers" as S, "Parts" as P, "Catalog" as C
WHERE (S.sid=C.sid AND C.pid=P.pid AND P.color='Red') OR S.address='221 Packer Street';

-- Find the sids of suppliers who supply every red or green part.
SELECT s.sid FROM "Suppliers" as s
WHERE NOT EXISTS (
	(SELECT p.pid FROM "Parts" as p WHERE p.color='Red' OR p.color='Green')
	EXCEPT
	(SELECT sp.pid FROM "Catalog" as sp WHERE sp.sid = s.sid)
);

-- Find the sids of suppliers who supply every red part or supply every green part.
SELECT s.sid FROM "Suppliers" as s
WHERE NOT EXISTS (
	(SELECT p.pid FROM "Parts" as p WHERE p.color='Red')
	EXCEPT
	(SELECT sp.pid FROM "Catalog" as sp WHERE sp.sid = s.sid)
) OR NOT EXISTS (
	(SELECT p.pid FROM "Parts" as p WHERE p.color='Green')
	EXCEPT
	(SELECT sp.pid FROM "Catalog" as sp WHERE sp.sid = s.sid)
);

-- Find pairs of sids such that the supplier with the first sid charges more for some part than the supplier with the second sid.
SELECT DISTINCT a.sid, b.sid
FROM "Catalog" as a
INNER JOIN "Catalog" as b 
ON a.cost > b.cost AND a.pid=b.pid

-- Find the pids of parts supplied by at least two different suppliers.
SELECT DISTINCT a.pid
FROM "Catalog" as a
INNER JOIN "Catalog" as b 
ON a.pid=b.pid AND a.sid!=b.sid

-- find the average cost of the red parts and green parts for each of the suppliers
SELECT sid, AVG(cost)
FROM (SELECT c.sid, c.pid, c.cost, p.pname, p.color
FROM "Catalog" as c
INNER JOIN "Parts" as p 
ON c.pid=p.pid) as b
WHERE b.color='Green' OR b.color='Red'
GROUP BY sid

-- find the sids of suppliers whose most expensive part costs $50 or more
SELECT DISTINCT sid
FROM "Catalog"
WHERE cost>=50