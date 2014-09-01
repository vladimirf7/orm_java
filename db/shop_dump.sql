--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: update_category_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_category_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.category_updated = cast(extract(epoch from now()) as integer);
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_category_timestamp() OWNER TO postgres;

--
-- Name: update_comment_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_comment_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.comment_updated = cast(extract(epoch from now()) as integer);
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_comment_timestamp() OWNER TO postgres;

--
-- Name: update_post_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_post_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.post_updated = cast(extract(epoch from now()) as integer);
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_post_timestamp() OWNER TO postgres;

--
-- Name: update_section_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_section_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.section_updated = cast(extract(epoch from now()) as integer);
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_section_timestamp() OWNER TO postgres;

--
-- Name: update_tag_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_tag_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.tag_updated = cast(extract(epoch from now()) as integer);
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_tag_timestamp() OWNER TO postgres;

--
-- Name: update_user_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_user_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.user_updated = cast(extract(epoch from now()) as integer);
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_user_timestamp() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE category (
    category_id integer NOT NULL,
    category_title character varying,
    category_created integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    category_updated integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    section_id integer NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: category_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE category_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_category_id_seq OWNER TO postgres;

--
-- Name: category_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE category_category_id_seq OWNED BY category.category_id;


--
-- Name: comment; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comment (
    comment_id integer NOT NULL,
    comment_date integer,
    comment_text character varying(255),
    comment_author character varying(255),
    comment_created integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    comment_updated integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    user_id integer NOT NULL,
    post_id integer NOT NULL
);


ALTER TABLE public.comment OWNER TO postgres;

--
-- Name: comment_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE comment_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comment_comment_id_seq OWNER TO postgres;

--
-- Name: comment_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE comment_comment_id_seq OWNED BY comment.comment_id;


--
-- Name: post; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE post (
    post_id integer NOT NULL,
    post_content text,
    post_title character varying(255),
    post_created integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    post_updated integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.post OWNER TO postgres;

--
-- Name: post__tag; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE post__tag (
    post_id integer NOT NULL,
    tag_id integer NOT NULL
);


ALTER TABLE public.post__tag OWNER TO postgres;

--
-- Name: post_post_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE post_post_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_post_id_seq OWNER TO postgres;

--
-- Name: post_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE post_post_id_seq OWNED BY post.post_id;


--
-- Name: section; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE section (
    section_id integer NOT NULL,
    section_title character varying(255),
    section_created integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    section_updated integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL
);


ALTER TABLE public.section OWNER TO postgres;

--
-- Name: section_section_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE section_section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.section_section_id_seq OWNER TO postgres;

--
-- Name: section_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE section_section_id_seq OWNED BY section.section_id;


--
-- Name: tag; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tag (
    tag_id integer NOT NULL,
    tag_name character varying(255),
    tag_created integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    tag_updated integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL
);


ALTER TABLE public.tag OWNER TO postgres;

--
-- Name: tag_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tag_tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tag_tag_id_seq OWNER TO postgres;

--
-- Name: tag_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tag_tag_id_seq OWNED BY tag.tag_id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "user" (
    user_id integer NOT NULL,
    user_name character varying(255),
    user_email character varying(255),
    user_created integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    user_updated integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_user_id_seq OWNER TO postgres;

--
-- Name: user_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_user_id_seq OWNED BY "user".user_id;


--
-- Name: category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY category ALTER COLUMN category_id SET DEFAULT nextval('category_category_id_seq'::regclass);


--
-- Name: comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment ALTER COLUMN comment_id SET DEFAULT nextval('comment_comment_id_seq'::regclass);


--
-- Name: post_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post ALTER COLUMN post_id SET DEFAULT nextval('post_post_id_seq'::regclass);


--
-- Name: section_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY section ALTER COLUMN section_id SET DEFAULT nextval('section_section_id_seq'::regclass);


--
-- Name: tag_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tag ALTER COLUMN tag_id SET DEFAULT nextval('tag_tag_id_seq'::regclass);


--
-- Name: user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "user" ALTER COLUMN user_id SET DEFAULT nextval('user_user_id_seq'::regclass);


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY category (category_id, category_title, category_created, category_updated, section_id) FROM stdin;
1	Java	1409589553	1409589553	1
2	C++	1409589553	1409589553	1
3	PHP	1409589553	1409589553	1
4	Python	1409589554	1409589554	1
5	Lisp	1409605237	1409605237	1
6	Lisp	1409605308	1409605308	1
7	Lisp	1409605627	1409605627	1
8	Lisp	1409605659	1409605659	1
9	Lisp	1409605734	1409605734	1
10	Lisp	1409605744	1409605744	1
11	Lisp	1409605769	1409605769	1
\.


--
-- Name: category_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('category_category_id_seq', 11, true);


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY comment (comment_id, comment_date, comment_text, comment_author, comment_created, comment_updated, user_id, post_id) FROM stdin;
\.


--
-- Name: comment_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('comment_comment_id_seq', 1, false);


--
-- Data for Name: post; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY post (post_id, post_content, post_title, post_created, post_updated, category_id) FROM stdin;
2	This article is the first in a multi-part series from the author of Sams Teach Yourself Scratch 2.0 in 24 Hours in which we create an online game by using the Scratch 2.0 educational programming language.	Building a Game from Scratch, Part 1: Setting the Foundation	1409590142	1409590142	1
3	C has a rich variety of math operators that you can use to manipulate your data. In this chapter from Programming in C, 4th Edition, Stephen G. Kochan covers the int, float, double, char, and _Bool data types, modifying data types with short, long, and long long, the rules for naming variables, basic math operators and arithmetic expressions, and type casting.	How to Work with Variables, Data Types, and Arithmetic Expressions in the C Programming Language	1409590142	1409590142	2
4	In Part 2 of a two-part series, programming expert Jesse Smith continues his discussion of Angular JS by exploring modules and services.	Angular JS Fundamental Concepts for Building Web Applications: Part 2	1409590142	1409590142	3
5	To mark the release of the official multi-format ebook of Donald Knuths Art of Computer Programming, Volume 3: Sorting and Searching, 2nd Edition, we are pleased to make available the preface.	Preface to The Art of Computer Programming, Volume 3: Sorting and Searching, 2nd Edition	1409590142	1409590142	3
6	Stephan G. Kochan provides some background about the C programming language and describes the contents and organization of the fourth edition of his book, Programming in C.	Introduction to Programming in PHP, Fourth Edition	1409590142	1409590142	3
7	Dave Hendricksen introduces his book, 12 More Essential Skills for Software Architects; learn the three sets of skills that will have the greatest impact on your ability to succeed and ascend.	Preface to 12 More Essential Skills for Software Architects	1409590145	1409590145	4
1	This chapter from 12 More Essential Skills for Software Architects unveils one of the essential skills needed by a software architect: the ability to identify, assess, and infuse new and potentially disruptive technologies in a business-centric fashion.	Very interesting content	1409589937	1409603696	1
\.


--
-- Data for Name: post__tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY post__tag (post_id, tag_id) FROM stdin;
\.


--
-- Name: post_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('post_post_id_seq', 7, true);


--
-- Data for Name: section; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY section (section_id, section_title, section_created, section_updated) FROM stdin;
1	Programming	1409589366	1409589366
\.


--
-- Name: section_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('section_section_id_seq', 1, true);


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tag (tag_id, tag_name, tag_created, tag_updated) FROM stdin;
1	Beginner	1409590312	1409590312
2	Intermediate	1409590312	1409590312
3	Advanced	1409590313	1409590313
4	Math	1409590347	1409590347
5	Trick	1409590347	1409590347
6	New feature	1409590348	1409590348
\.


--
-- Name: tag_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tag_tag_id_seq', 6, true);


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "user" (user_id, user_name, user_email, user_created, user_updated) FROM stdin;
\.


--
-- Name: user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_user_id_seq', 1, false);


--
-- Name: category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (category_id);


--
-- Name: comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (comment_id);


--
-- Name: post__tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY post__tag
    ADD CONSTRAINT post__tag_pkey PRIMARY KEY (post_id, tag_id);


--
-- Name: post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY post
    ADD CONSTRAINT post_pkey PRIMARY KEY (post_id);


--
-- Name: section_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY section
    ADD CONSTRAINT section_pkey PRIMARY KEY (section_id);


--
-- Name: tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (tag_id);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);


--
-- Name: tr_category_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_category_updated BEFORE UPDATE ON category FOR EACH ROW EXECUTE PROCEDURE update_category_timestamp();


--
-- Name: tr_comment_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_comment_updated BEFORE UPDATE ON comment FOR EACH ROW EXECUTE PROCEDURE update_comment_timestamp();


--
-- Name: tr_post_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_post_updated BEFORE UPDATE ON post FOR EACH ROW EXECUTE PROCEDURE update_post_timestamp();


--
-- Name: tr_section_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_section_updated BEFORE UPDATE ON section FOR EACH ROW EXECUTE PROCEDURE update_section_timestamp();


--
-- Name: tr_tag_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_tag_updated BEFORE UPDATE ON tag FOR EACH ROW EXECUTE PROCEDURE update_tag_timestamp();


--
-- Name: tr_user_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_user_updated BEFORE UPDATE ON "user" FOR EACH ROW EXECUTE PROCEDURE update_user_timestamp();


--
-- Name: fk_category_section_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY category
    ADD CONSTRAINT fk_category_section_id FOREIGN KEY (section_id) REFERENCES section(section_id);


--
-- Name: fk_comment_post_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT fk_comment_post_id FOREIGN KEY (post_id) REFERENCES post(post_id);


--
-- Name: fk_comment_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT fk_comment_user_id FOREIGN KEY (user_id) REFERENCES "user"(user_id);


--
-- Name: fk_post__tag_post_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post__tag
    ADD CONSTRAINT fk_post__tag_post_id FOREIGN KEY (post_id) REFERENCES post(post_id);


--
-- Name: fk_post__tag_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post__tag
    ADD CONSTRAINT fk_post__tag_tag_id FOREIGN KEY (tag_id) REFERENCES tag(tag_id);


--
-- Name: fk_post_category_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY post
    ADD CONSTRAINT fk_post_category_id FOREIGN KEY (category_id) REFERENCES category(category_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

