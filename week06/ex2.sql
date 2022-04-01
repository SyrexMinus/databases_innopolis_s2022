-- Table: public.Author

-- DROP TABLE public."Author";

CREATE TABLE IF NOT EXISTS public."Author"
(
    author_id integer NOT NULL,
    first_name text COLLATE pg_catalog."default",
    last_name text COLLATE pg_catalog."default",
    CONSTRAINT "Author_pkey" PRIMARY KEY (author_id)
)

TABLESPACE pg_default;

ALTER TABLE public."Author"
    OWNER to postgres;

-- Table: public.AuthorPub

-- DROP TABLE public."AuthorPub";

CREATE TABLE IF NOT EXISTS public."AuthorPub"
(
    author_id integer NOT NULL,
    pub_id integer NOT NULL,
    author_position integer,
    CONSTRAINT "AuthorPub_pkey" PRIMARY KEY (author_id, pub_id)
)

TABLESPACE pg_default;

ALTER TABLE public."AuthorPub"
    OWNER to postgres;

-- Table: public.Book

-- DROP TABLE public."Book";

CREATE TABLE IF NOT EXISTS public."Book"
(
    book_id integer NOT NULL,
    book_title text COLLATE pg_catalog."default",
    month text COLLATE pg_catalog."default",
    year integer,
    editor integer,
    CONSTRAINT "Book_pkey" PRIMARY KEY (book_id)
)

TABLESPACE pg_default;

ALTER TABLE public."Book"
    OWNER to postgres;

-- Table: public.Pub

-- DROP TABLE public."Pub";

CREATE TABLE IF NOT EXISTS public."Pub"
(
    pub_id integer NOT NULL,
    title text COLLATE pg_catalog."default",
    book_id integer,
    CONSTRAINT "Pub_pkey" PRIMARY KEY (pub_id)
)

TABLESPACE pg_default;

ALTER TABLE public."Pub"
    OWNER to postgres;

-- 1
SELECT *
FROM "Author" as a
INNER JOIN "Book" as b 
ON a.author_id=b.editor

-- 2
SELECT DISTINCT x.first_name, x.last_name
FROM (
	SELECT DISTINCT *
	FROM (
		SELECT DISTINCT a.author_id
		FROM "Author" as a
		EXCEPT
		SELECT DISTINCT b.editor
		FROM "Book" as b
	) as y
	INNER JOIN "Author" as c
	ON 1=1
) as x

-- 3
SELECT DISTINCT author_id
FROM "Author"
EXCEPT
SELECT DISTINCT editor
FROM "Book"