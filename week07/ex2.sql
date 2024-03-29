-- 1NF: relation already in 1NF, since there is no duplicated tuples, no repeating groups and columns are atomic

-- 2NF:
-- LoanBook: loan_id, loaner_id, book_id, loan_date
-- Loaner: loaner_id, school, teacher, course, room, grade
-- Book: book_id, book_name, publisher

-- 3NF:
CREATE TABLE IF NOT EXISTS public."Publisher"
(
    publisher_id integer NOT NULL,
    publisher_name character(255),
    PRIMARY KEY (publisher_id)
);

ALTER TABLE public."Publisher"
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public."Grade"
(
    grade_id integer NOT NULL,
    grade_name character(255),
    PRIMARY KEY (grade_id)
);

ALTER TABLE public."Grade"
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public."Room"
(
    room_id integer NOT NULL,
    room_name character(255),
    PRIMARY KEY (room_id)
);

ALTER TABLE public."Room"
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public."Course"
(
    course_id integer NOT NULL,
    course_name character(255),
    PRIMARY KEY (course_id)
);

ALTER TABLE public."Course"
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public."Teacher"
(
    teacher_id integer NOT NULL,
    teacher_name character(255),
    PRIMARY KEY (teacher_id)
);

ALTER TABLE public."Teacher"
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public."School"
(
    school_id integer NOT NULL,
    school_name character(255),
    PRIMARY KEY (school_id)
);

ALTER TABLE public."School"
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public."Book"
(
    book_id integer NOT NULL,
    book_name character(255),
    publisher_id integer,
    FOREIGN KEY (publisher_id) REFERENCES "Publisher"(publisher_id),
    PRIMARY KEY (book_id)
);

ALTER TABLE public."Book"
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public."Loaner"
(
    loaner_id integer NOT NULL,
    school_id integer,
    FOREIGN KEY (school_id) REFERENCES "School"(school_id),
    teacher_id integer,
    FOREIGN KEY (teacher_id) REFERENCES "Teacher"(teacher_id),
    course_id integer,
    FOREIGN KEY (course_id) REFERENCES "Course"(course_id),
    room_id integer,
    FOREIGN KEY (room_id) REFERENCES "Room"(room_id),
    grade_id integer,
    FOREIGN KEY (grade_id) REFERENCES "Grade"(grade_id),
    PRIMARY KEY (loaner_id)
);

ALTER TABLE public."Loaner"
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public."LoanBook"
(
    loan_id integer NOT NULL,
    loaner_id integer,
    FOREIGN KEY (loaner_id) REFERENCES "Loaner"(loaner_id),
    book_id integer,
    FOREIGN KEY (book_id) REFERENCES "Book"(book_id),
    loan_date date,
    PRIMARY KEY (loan_id)
);

ALTER TABLE public."LoanBook"
    OWNER to postgres;

-- Obtain for each of the schools, the number of books that have been loaned to each publishers.
SELECT school_id, publisher_id, count(book_name) as loaned_number
FROM (
	SELECT *
	FROM (
		SELECT *
		FROM "LoanBook" as lb
		INNER JOIN "Loaner" as l
		ON l.loaner_id = lb.loaner_id
	) as x
	INNER JOIN "Book" as b
	ON b.book_id = x.book_id
) as x1
GROUP BY school_id, publisher_id

-- For each school, find the book that has been on loan the longest and the teacher in charge of it.
SELECT y.school_id, y.teacher_id
FROM (
	SELECT * 
	FROM "LoanBook" as lb
	INNER JOIN "Loaner" as l
	ON l.loaner_id = lb.loaner_id
) as y
INNER JOIN (
	SELECT school_id, min(loan_date) as min_loan_date
	FROM (
		SELECT *
		FROM (
			SELECT *
			FROM "LoanBook" as lb
			INNER JOIN "Loaner" as l
			ON l.loaner_id = lb.loaner_id
		) as x
		INNER JOIN "Book" as b
		ON b.book_id = x.book_id
	) as x1
	GROUP BY school_id
) as x2
ON y.school_id=x2.school_id AND y.loan_date=x2.min_loan_date