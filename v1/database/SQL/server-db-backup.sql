--
-- PostgreSQL database cluster dump
--

-- Started on 2023-12-19 12:27:21

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:yOgsTYNWnkg2dyxlbvx0yg==$WQ9tb+gJYkOnXHbDJTPSd5efw+kii07bvtJiBRzjxdA=:U9pgJlZWDaICVdPd7aUIr9Y8dtCSFT5TTipSH1zwt7E=';

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

-- Started on 2023-12-19 12:27:21

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2023-12-19 12:27:22

--
-- PostgreSQL database dump complete
--

--
-- Database "school" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

-- Started on 2023-12-19 12:27:22

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3401 (class 1262 OID 16554)
-- Name: school; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE school WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Arabic_Saudi Arabia.1256';


ALTER DATABASE school OWNER TO postgres;

\connect school

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3402 (class 0 OID 0)
-- Name: school; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE school SET default_text_search_config TO 'pg_catalog.english';


\connect school

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16555)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 3403 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 233 (class 1255 OID 16859)
-- Name: school_code(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.school_code() RETURNS text
    LANGUAGE plpgsql
    AS $$
  DECLARE
    random_code TEXT;
  BEGIN
    -- Generate a random code and check for uniqueness
    LOOP
      random_code := CONCAT(LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3));
      -- Check if the generated code is unique in your table
      EXIT WHEN NOT EXISTS (SELECT 1 FROM schools WHERE code = random_code);
    END LOOP;
    RETURN random_code;
  END;
$$;


ALTER FUNCTION public.school_code() OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 16775)
-- Name: user_code(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.user_code() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  random_code TEXT;
BEGIN
  -- Generate a random code and check for uniqueness
  LOOP
    random_code := CONCAT(LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3));
    
    -- Check if the generated code is unique in your table
    EXIT WHEN NOT EXISTS (SELECT 1 FROM users WHERE code = random_code);
  END LOOP;
  
  RETURN random_code;
END;
$$;


ALTER FUNCTION public.user_code() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16979)
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    uid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    teacher character varying(255) NOT NULL,
    price numeric(10,2) NOT NULL,
    school character varying(11),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17251)
-- Name: lessons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lessons (
    uid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    school character varying(11),
    course uuid,
    presents uuid[],
    absents uuid[],
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.lessons OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17139)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    uid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    school character varying(11),
    user_code character varying(11),
    user_name character varying(255) NOT NULL,
    student uuid,
    course uuid,
    course_name character varying(255) NOT NULL,
    price numeric NOT NULL,
    quantity integer NOT NULL,
    total numeric NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16961)
-- Name: schools; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schools (
    code character varying(11) DEFAULT public.school_code() NOT NULL,
    name character varying(250),
    email character varying(250),
    created_at timestamp with time zone DEFAULT now(),
    license_end timestamp with time zone DEFAULT (now() + '30 days'::interval)
);


ALTER TABLE public.schools OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16992)
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    uid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    birthday character varying(10) NOT NULL,
    email character varying(255),
    phone character varying(20),
    school character varying(11),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16950)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    code character varying(11) DEFAULT public.user_code() NOT NULL,
    email character varying(250) NOT NULL,
    password text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16971)
-- Name: users_schools; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_schools (
    user_code character varying(11) NOT NULL,
    school_code character varying(11) NOT NULL,
    role character varying(250) NOT NULL,
    status character varying(250) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.users_schools OWNER TO postgres;

--
-- TOC entry 3392 (class 0 OID 16979)
-- Dependencies: 218
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (uid, name, teacher, price, school, created_at) FROM stdin;
f940378b-9938-4dbf-86da-5bc1cfce626c	computer Science	Mohamed berkane	600.00	360-c6a-20b	2023-11-24 14:35:46.193881+01
c749de04-7f24-47f5-9903-5dc50e5b59e5	Math de 2 année lycée	Laziri amar	500.00	360-c6a-20b	2023-11-24 14:35:46.193881+01
857dcf2c-95f1-4634-8249-423e8c01b081	علوم الحاسوب	عمر لعزيري	1000.00	360-c6a-20b	2023-11-24 14:35:46.193881+01
d8ecd275-29e7-4a4f-8452-f0a742529a46	Math de 4 année lycée	Laziri amar	500.00	360-c6a-20b	2023-11-24 14:35:46.193881+01
cfb72835-0126-4596-ad4c-a4669ca1fb6d	العربية	محمد	650.00	360-c6a-20b	2023-11-28 07:22:39.380183+01
c9f5f855-ef3a-4421-9600-dffc6f921dbb	English 1 st	adam	500.00	360-c6a-20b	2023-11-29 07:49:51.993573+01
12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	teri bark	600.00	360-c6a-20b	2023-11-29 21:50:22.386187+01
084e821e-dc42-4819-a473-c0915d0cc2b3	courses	teacher	1000.00	360-c6a-20b	2023-12-01 07:29:38.43676+01
ee298d5b-fe1f-47ee-9896-606f330dcb6f	test couse	teachers	1520.00	ef9-45b-c74	2023-12-03 21:23:31.305505+01
42fbae29-e9ba-4160-b797-f90ce5ebca88	isam el-dars	el-chikh	1000.00	360-c6a-20b	2023-12-12 18:31:20.779586+01
\.


--
-- TOC entry 3395 (class 0 OID 17251)
-- Dependencies: 221
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lessons (uid, school, course, presents, absents, created_at) FROM stdin;
aefa88e0-6628-436c-8bd3-98c69ed53c74	360-c6a-20b	084e821e-dc42-4819-a473-c0915d0cc2b3	{}	{}	2023-12-05 20:46:04.441007+01
9ab85b38-d816-464e-ba39-06f4aa63de12	360-c6a-20b	084e821e-dc42-4819-a473-c0915d0cc2b3	{}	{}	2023-12-07 07:54:23.105707+01
6a73768a-4fe4-4e88-b100-46cfd536b56e	360-c6a-20b	f940378b-9938-4dbf-86da-5bc1cfce626c	{130ec73c-a7b2-4244-ba61-f463e7d6d9e7}	{}	2023-12-08 14:02:37.10465+01
155edebc-44a4-41ad-8c27-4e9ebb6aafd1	360-c6a-20b	f940378b-9938-4dbf-86da-5bc1cfce626c	{130ec73c-a7b2-4244-ba61-f463e7d6d9e7,93e76b3a-8f8a-4a06-bf80-7c761a884de8}	{}	2023-12-08 14:03:11.323486+01
4307c0ce-755a-407b-b96d-5fff151961e7	360-c6a-20b	084e821e-dc42-4819-a473-c0915d0cc2b3	{f63ea4e1-dad7-492d-ae56-c0ac624978e0,93e76b3a-8f8a-4a06-bf80-7c761a884de8,ab474898-6d44-45fa-925d-ffa7c836593b,d8f1df82-4897-4be0-af24-cb1eb75c5e88,302f5e97-684f-4c64-9c30-998d985dba21,09f8dabe-9bfb-482e-9890-680fafce1e65}	{}	2023-12-08 14:16:37.149496+01
963763ca-fa3d-4756-96e5-d7b0dac1b1f1	360-c6a-20b	084e821e-dc42-4819-a473-c0915d0cc2b3	{302f5e97-684f-4c64-9c30-998d985dba21,93e76b3a-8f8a-4a06-bf80-7c761a884de8}	{f63ea4e1-dad7-492d-ae56-c0ac624978e0,09f8dabe-9bfb-482e-9890-680fafce1e65,ab474898-6d44-45fa-925d-ffa7c836593b,d8f1df82-4897-4be0-af24-cb1eb75c5e88}	2023-12-08 14:34:06.966926+01
2fbc92cf-59f8-476a-8ad7-9134029985f4	360-c6a-20b	f940378b-9938-4dbf-86da-5bc1cfce626c	{130ec73c-a7b2-4244-ba61-f463e7d6d9e7,49c186af-3c01-489b-a432-cf7f47c1896c,93e76b3a-8f8a-4a06-bf80-7c761a884de8}	{d8f1df82-4897-4be0-af24-cb1eb75c5e88}	2023-12-09 10:46:56.794106+01
cae48a7a-3bc4-4a3c-bf11-d52c81de0aeb	360-c6a-20b	084e821e-dc42-4819-a473-c0915d0cc2b3	{09f8dabe-9bfb-482e-9890-680fafce1e65,302f5e97-684f-4c64-9c30-998d985dba21,93e76b3a-8f8a-4a06-bf80-7c761a884de8,ab474898-6d44-45fa-925d-ffa7c836593b,f63ea4e1-dad7-492d-ae56-c0ac624978e0}	{d8f1df82-4897-4be0-af24-cb1eb75c5e88}	2023-12-08 06:54:56.70324+01
3210c057-ecc4-4796-b6fd-06a0057b3cf9	360-c6a-20b	084e821e-dc42-4819-a473-c0915d0cc2b3	{93e76b3a-8f8a-4a06-bf80-7c761a884de8}	{d8f1df82-4897-4be0-af24-cb1eb75c5e88,ab474898-6d44-45fa-925d-ffa7c836593b}	2023-12-07 07:55:04.525916+01
5d48b7a6-d059-43a4-80cd-629b1e18552e	360-c6a-20b	f940378b-9938-4dbf-86da-5bc1cfce626c	{49c186af-3c01-489b-a432-cf7f47c1896c,130ec73c-a7b2-4244-ba61-f463e7d6d9e7}	{93e76b3a-8f8a-4a06-bf80-7c761a884de8}	2023-12-08 14:07:09.266662+01
cbdf79ef-c7e0-4bd0-a652-d7ee3daaf5bc	360-c6a-20b	084e821e-dc42-4819-a473-c0915d0cc2b3	{93e76b3a-8f8a-4a06-bf80-7c761a884de8,119ae0e7-70c7-4c17-82ca-e1907cd14465,f63ea4e1-dad7-492d-ae56-c0ac624978e0}	{ab474898-6d44-45fa-925d-ffa7c836593b,d8f1df82-4897-4be0-af24-cb1eb75c5e88,302f5e97-684f-4c64-9c30-998d985dba21,09f8dabe-9bfb-482e-9890-680fafce1e65,e1b7ac51-5113-4f1a-92bb-89c4be479726}	2023-12-11 07:31:47.710027+01
99de1e6e-4199-4d50-9439-a49f6ddb2935	360-c6a-20b	c9f5f855-ef3a-4421-9600-dffc6f921dbb	{}	{}	2023-12-12 20:05:15.917032+01
66f3a4aa-2c35-4ea5-8ea1-b5aae3e23c45	360-c6a-20b	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	{e1b7ac51-5113-4f1a-92bb-89c4be479726}	{}	2023-12-12 20:03:07.242467+01
e5da629d-6e13-42c1-bece-6a07f5c41576	360-c6a-20b	42fbae29-e9ba-4160-b797-f90ce5ebca88	{130ec73c-a7b2-4244-ba61-f463e7d6d9e7,896d2da1-360e-41be-b3ca-ce242acbe20b,49c186af-3c01-489b-a432-cf7f47c1896c,c940f954-a47d-4654-9e78-a05cb6c11de8,302f5e97-684f-4c64-9c30-998d985dba21,d8f1df82-4897-4be0-af24-cb1eb75c5e88,960d83c1-dcf4-4235-87c9-b211a25f4b35}	{}	2023-12-17 20:35:42.359485+01
\.


--
-- TOC entry 3394 (class 0 OID 17139)
-- Dependencies: 220
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (uid, school, user_code, user_name, student, course, course_name, price, quantity, total, created_at) FROM stdin;
ddb0d310-c050-4c08-9083-f51fe3406712	360-c6a-20b	701-a8c-d80	trissiti19	130ec73c-a7b2-4244-ba61-f463e7d6d9e7	f940378b-9938-4dbf-86da-5bc1cfce626c	computer Science	600.00	1	600	2023-11-29 18:32:54.514863+01
625f824b-66ac-472e-8c0c-3aaa5f4beec7	360-c6a-20b	701-a8c-d80	trissiti19	130ec73c-a7b2-4244-ba61-f463e7d6d9e7	c9f5f855-ef3a-4421-9600-dffc6f921dbb	English 1 st	500.00	1	500	2023-11-29 18:39:38.719846+01
eba9d921-34f9-4b9d-845f-34f9029b825f	360-c6a-20b	701-a8c-d80	trissiti19	130ec73c-a7b2-4244-ba61-f463e7d6d9e7	c749de04-7f24-47f5-9903-5dc50e5b59e5	Math de 2 année lycée	500.00	1	500	2023-11-29 18:45:31.332456+01
9bf3a485-2225-4969-98e3-164deddf21f7	360-c6a-20b	701-a8c-d80	trissiti19	960d83c1-dcf4-4235-87c9-b211a25f4b35	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-11-29 21:51:09.277962+01
55e666a5-8d46-4239-806e-7d511466a030	360-c6a-20b	701-a8c-d80	trissiti19	960d83c1-dcf4-4235-87c9-b211a25f4b35	cfb72835-0126-4596-ad4c-a4669ca1fb6d	العربية	650.00	1	650	2023-11-29 21:51:12.350212+01
230f0419-68c7-4c47-82ae-af2233c0f564	360-c6a-20b	701-a8c-d80	trissiti19	960d83c1-dcf4-4235-87c9-b211a25f4b35	c9f5f855-ef3a-4421-9600-dffc6f921dbb	English 1 st	500.00	1	500	2023-11-29 21:51:26.584088+01
dcf08405-ab8b-49b5-899d-d8db300b50b3	360-c6a-20b	701-a8c-d80	trissiti19	960d83c1-dcf4-4235-87c9-b211a25f4b35	857dcf2c-95f1-4634-8249-423e8c01b081	علوم الحاسوب	1000.00	1	1000	2023-11-29 21:52:21.548736+01
03ae00ee-9b7e-4f0d-8b65-0dfbe7b2de32	360-c6a-20b	701-a8c-d80	trissiti19	960d83c1-dcf4-4235-87c9-b211a25f4b35	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-11-29 21:54:42.302833+01
2e8b0b84-8ff5-4c40-ad02-06fb135f9825	360-c6a-20b	701-a8c-d80	trissiti19	f00ee94f-05cb-4327-bc37-e7ee0f401e81	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-12-01 08:21:34.61416+01
063b5395-7f11-4cb5-b06c-7c47d7dbc5cf	360-c6a-20b	701-a8c-d80	trissiti19	b9b08214-665d-4bb4-8b55-925ab7e93989	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	6	3600	2023-12-01 08:37:28.832664+01
45cf052c-0969-4826-91d6-ca714a41adb9	360-c6a-20b	701-a8c-d80	trissiti19	c0238942-73e5-4482-b0c4-6e9ea1af1cd3	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	3	1800	2023-12-01 08:37:40.295605+01
ccb49c3b-1f0c-464c-8b59-648732a7ed24	360-c6a-20b	701-a8c-d80	trissiti19	9f7aa900-b6ae-49b2-ae5c-6714d30c8a81	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-12-01 08:37:49.118329+01
f4bf7df1-db06-44cc-b06b-63b850fa8640	360-c6a-20b	701-a8c-d80	trissiti19	ff278095-2773-4963-8c57-4ea0e4c1977b	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	5	3000	2023-12-01 08:37:58.914292+01
d27ca2c5-501f-46a1-874a-6a30356c4516	360-c6a-20b	701-a8c-d80	trissiti19	af8fe744-a420-4ff6-a8db-e3fe1acd78c7	c9f5f855-ef3a-4421-9600-dffc6f921dbb	English 1 st	500.00	1	500	2023-12-01 08:38:06.629455+01
60c108e8-d2ec-474f-9207-65f8a34d6b92	360-c6a-20b	701-a8c-d80	trissiti19	d8f1df82-4897-4be0-af24-cb1eb75c5e88	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-12-03 07:17:09.890077+01
76619f50-078a-4b7b-9757-382681e181bc	360-c6a-20b	701-a8c-d80	trissiti19	d8f1df82-4897-4be0-af24-cb1eb75c5e88	857dcf2c-95f1-4634-8249-423e8c01b081	علوم الحاسوب	1000.00	5	5000	2023-12-03 07:21:53.688278+01
535ceef5-1511-438a-a96a-3c174c31ea3c	360-c6a-20b	701-a8c-d80	trissiti19	d8f1df82-4897-4be0-af24-cb1eb75c5e88	c9f5f855-ef3a-4421-9600-dffc6f921dbb	English 1 st	500.00	1	500	2023-12-03 07:33:29.626366+01
c6ee9546-772f-46ab-8b81-4f5c03ec2b8b	360-c6a-20b	701-a8c-d80	trissiti19	d8f1df82-4897-4be0-af24-cb1eb75c5e88	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-12-03 07:37:46.263983+01
56253484-30bb-41c1-a150-51113e4cfdb1	360-c6a-20b	701-a8c-d80	trissiti19	6c0c3b58-368a-484a-a274-39014529c0f7	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-12-03 07:40:33.3507+01
0a1a409f-0ed7-4a0a-a91e-141fb5646631	360-c6a-20b	701-a8c-d80	trissiti19	6c0c3b58-368a-484a-a274-39014529c0f7	857dcf2c-95f1-4634-8249-423e8c01b081	علوم الحاسوب	1000.00	1	1000	2023-12-03 07:41:45.557032+01
7f395985-df06-4e5e-8099-e6d3757fb93c	360-c6a-20b	701-a8c-d80	trissiti19	130ec73c-a7b2-4244-ba61-f463e7d6d9e7	857dcf2c-95f1-4634-8249-423e8c01b081	علوم الحاسوب	1000.00	4	4000	2023-12-03 20:39:35.929587+01
7cc28aed-2b10-421b-bdaa-7dd6372be4c1	360-c6a-20b	701-a8c-d80	trissiti19	62215883-390b-4fb0-a51b-f89e33b2e9aa	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	3	1800	2023-12-03 21:11:49.229422+01
b775bbd6-5e8a-43cb-a0e4-4a1de9c9d18f	360-c6a-20b	701-a8c-d80	trissiti19	f8d1bb77-240f-46c7-a549-26a26e9ed269	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-12-03 21:12:03.957119+01
6429abfb-2bc0-445b-b2c9-a3af3f6dfe50	360-c6a-20b	701-a8c-d80	trissiti19	d6c9fbcb-c16c-4d4f-ae93-17b988048028	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-12-03 21:12:12.808156+01
81893103-94ad-423b-a750-10da5f60eb1f	360-c6a-20b	701-a8c-d80	trissiti19	09f8dabe-9bfb-482e-9890-680fafce1e65	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-12-03 21:12:21.165851+01
712975ce-97fe-4305-97ad-5874f544e171	360-c6a-20b	701-a8c-d80	trissiti19	49c186af-3c01-489b-a432-cf7f47c1896c	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-12-03 21:12:34.375322+01
3a1781f6-4b2b-46c9-9e0a-688e2d3a7f7a	360-c6a-20b	701-a8c-d80	trissiti19	c18d2eda-90d9-4dc9-8284-951c38e7a9a0	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-12-03 21:12:46.239508+01
1b3274b7-9f09-48c9-8487-e67c53829292	360-c6a-20b	701-a8c-d80	trissiti19	d038aeb1-98c2-41a5-ab02-793d1d51f643	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-12-03 21:13:00.546681+01
d7931438-3ca6-425f-b2bb-c8b5071ab10b	ef9-45b-c74	991-15c-c2f	laziriamar100	25511ca4-bb25-4238-9531-90c4ea577c6a	ee298d5b-fe1f-47ee-9896-606f330dcb6f	test couse	1520.00	1	1520	2023-12-03 21:35:08.830477+01
86073875-f280-412c-ac59-9727fef48f1d	ef9-45b-c74	991-15c-c2f	laziriamar100	25511ca4-bb25-4238-9531-90c4ea577c6a	ee298d5b-fe1f-47ee-9896-606f330dcb6f	test couse	1520.00	6	9000	2023-12-03 21:44:28.218738+01
b84d8ab2-c96c-4f3a-ac9a-f97ce4afe2b1	360-c6a-20b	701-a8c-d80	trissiti19	d8f1df82-4897-4be0-af24-cb1eb75c5e88	084e821e-dc42-4819-a473-c0915d0cc2b3	courses	1000.00	1	1000	2023-12-07 07:54:36.261232+01
b4bde363-3325-43b8-b54b-0229c077aa6c	360-c6a-20b	701-a8c-d80	trissiti19	93e76b3a-8f8a-4a06-bf80-7c761a884de8	084e821e-dc42-4819-a473-c0915d0cc2b3	courses	1000.00	1	1000	2023-12-07 07:54:47.547134+01
c0c43f4f-7fdf-4fcf-9e7d-291e441bfa17	360-c6a-20b	701-a8c-d80	trissiti19	ab474898-6d44-45fa-925d-ffa7c836593b	084e821e-dc42-4819-a473-c0915d0cc2b3	courses	1000.00	2	2000	2023-12-07 07:54:59.456705+01
6e55dd33-e630-4bd7-b7e0-bcd55c44e0e6	360-c6a-20b	701-a8c-d80	trissiti19	302f5e97-684f-4c64-9c30-998d985dba21	084e821e-dc42-4819-a473-c0915d0cc2b3	courses	1000.00	1	1000	2023-12-08 06:53:54.377838+01
e3bc84a2-1533-4d2f-b8e7-bc79b42c6685	360-c6a-20b	701-a8c-d80	trissiti19	f63ea4e1-dad7-492d-ae56-c0ac624978e0	084e821e-dc42-4819-a473-c0915d0cc2b3	courses	1000.00	1	1000	2023-12-08 06:54:06.111223+01
81551402-8b9a-4acd-8929-34e5e38f32e3	360-c6a-20b	701-a8c-d80	trissiti19	09f8dabe-9bfb-482e-9890-680fafce1e65	084e821e-dc42-4819-a473-c0915d0cc2b3	courses	1000.00	1	1000	2023-12-08 06:54:17.970144+01
c87a5277-c4ac-49ba-af10-c82e91c60bfd	360-c6a-20b	701-a8c-d80	trissiti19	93e76b3a-8f8a-4a06-bf80-7c761a884de8	f940378b-9938-4dbf-86da-5bc1cfce626c	computer Science	600.00	1	600	2023-12-08 14:02:53.497019+01
5c47763b-9fbc-46f2-b77b-d877c4f4e05f	360-c6a-20b	701-a8c-d80	trissiti19	49c186af-3c01-489b-a432-cf7f47c1896c	f940378b-9938-4dbf-86da-5bc1cfce626c	computer Science	600.00	1	600	2023-12-08 14:06:46.65254+01
444e8b20-a908-4a63-953c-3aee3e3af93b	360-c6a-20b	701-a8c-d80	trissiti19	d8f1df82-4897-4be0-af24-cb1eb75c5e88	c749de04-7f24-47f5-9903-5dc50e5b59e5	Math de 2 année lycée	500.00	1	500	2023-12-09 08:22:04.029661+01
ab4e5cde-124c-4939-a1be-298c82420e0e	360-c6a-20b	701-a8c-d80	trissiti19	e1b7ac51-5113-4f1a-92bb-89c4be479726	084e821e-dc42-4819-a473-c0915d0cc2b3	courses	1000.00	1	1000	2023-12-09 08:32:20.52849+01
b355d22f-2b70-4a47-bf07-cb37f2d87467	360-c6a-20b	701-a8c-d80	trissiti19	e1b7ac51-5113-4f1a-92bb-89c4be479726	12d0e8ce-2fb2-481d-a176-ea86d72d9fb6	Arabic	600.00	1	600	2023-12-09 08:37:09.910479+01
68d07220-344d-48b1-b4a3-200a55f3d33a	360-c6a-20b	701-a8c-d80	trissiti19	e1b7ac51-5113-4f1a-92bb-89c4be479726	857dcf2c-95f1-4634-8249-423e8c01b081	علوم الحاسوب	1000.00	1	1000	2023-12-09 08:37:52.305352+01
16f1543c-a8a2-41e5-9ec4-5dee8f4f45cc	360-c6a-20b	701-a8c-d80	trissiti19	119ae0e7-70c7-4c17-82ca-e1907cd14465	084e821e-dc42-4819-a473-c0915d0cc2b3	courses	1000.00	1	1000	2023-12-09 08:39:06.249228+01
ad2fc3d5-40f4-40e5-8483-c2ed812db326	360-c6a-20b	701-a8c-d80	trissiti19	d8f1df82-4897-4be0-af24-cb1eb75c5e88	cfb72835-0126-4596-ad4c-a4669ca1fb6d	العربية	650.00	1	650	2023-12-09 09:19:18.540478+01
5eb9c540-40b3-42e6-bd0d-c01571cc3f3f	360-c6a-20b	701-a8c-d80	trissiti19	d8f1df82-4897-4be0-af24-cb1eb75c5e88	d8ecd275-29e7-4a4f-8452-f0a742529a46	Math de 4 année lycée	500.00	1	500	2023-12-09 10:30:55.617448+01
df370d1e-16b5-4bb3-a38a-c14b21c5f21c	360-c6a-20b	701-a8c-d80	trissiti19	d8f1df82-4897-4be0-af24-cb1eb75c5e88	f940378b-9938-4dbf-86da-5bc1cfce626c	computer Science	600.00	1	600	2023-12-09 10:30:58.285342+01
cd7f499a-8b48-47c3-95bf-596d41460896	360-c6a-20b	701-a8c-d80	trissiti19	0cf812ea-8372-45c7-85cc-02eff62bc079	f940378b-9938-4dbf-86da-5bc1cfce626c	computer Science	600.00	1	600	2023-12-09 10:53:23.393334+01
17888cfa-b0de-40e4-830d-cad0110b2edb	360-c6a-20b	701-a8c-d80	trissiti19	09f8dabe-9bfb-482e-9890-680fafce1e65	f940378b-9938-4dbf-86da-5bc1cfce626c	computer Science	600.00	1	600	2023-12-11 23:15:03.923446+01
491cc9b4-613b-477a-971c-a230eab21d96	360-c6a-20b	701-a8c-d80	trissiti19	130ec73c-a7b2-4244-ba61-f463e7d6d9e7	42fbae29-e9ba-4160-b797-f90ce5ebca88	dars	1000.00	2	2000	2023-12-12 20:05:00.775191+01
4d802596-fdbc-4eb9-a261-03bf6be0da96	360-c6a-20b	701-a8c-d80	trissiti19	49c186af-3c01-489b-a432-cf7f47c1896c	42fbae29-e9ba-4160-b797-f90ce5ebca88	dars	1000.00	1	1000	2023-12-12 20:35:35.018585+01
60ed739e-9e40-4f0e-8f93-59cd5bbd02cc	360-c6a-20b	701-a8c-d80	trissiti19	c940f954-a47d-4654-9e78-a05cb6c11de8	42fbae29-e9ba-4160-b797-f90ce5ebca88	dars	1000.00	3	3000	2023-12-12 20:35:50.877464+01
1cc48b9a-a3e2-4d27-a4e5-18c45cffa5a2	360-c6a-20b	701-a8c-d80	trissiti19	960d83c1-dcf4-4235-87c9-b211a25f4b35	42fbae29-e9ba-4160-b797-f90ce5ebca88	dars	1000.00	3	1000	2023-12-12 18:32:26.59322+01
243ceaf7-02af-4857-b7bb-c88da70697c1	360-c6a-20b	701-a8c-d80	trissiti19	49c186af-3c01-489b-a432-cf7f47c1896c	42fbae29-e9ba-4160-b797-f90ce5ebca88	dars	1000.00	1	1000	2023-12-13 22:05:04.643423+01
ff75e915-c856-4353-8d37-ad213bc0ae64	360-c6a-20b	701-a8c-d80	trissiti19	49c186af-3c01-489b-a432-cf7f47c1896c	42fbae29-e9ba-4160-b797-f90ce5ebca88	dars	1000.00	2	2000	2023-12-15 08:53:01.23204+01
7402e0d8-dd29-4403-a191-98be2bfd6017	360-c6a-20b	701-a8c-d80	trissiti19	49c186af-3c01-489b-a432-cf7f47c1896c	42fbae29-e9ba-4160-b797-f90ce5ebca88	dars	1000.00	-1	-1000	2023-12-15 08:55:57.985069+01
943dae68-56b4-440e-9506-8b77e599ad46	360-c6a-20b	701-a8c-d80	trissiti19	49c186af-3c01-489b-a432-cf7f47c1896c	42fbae29-e9ba-4160-b797-f90ce5ebca88	dars	1000.00	2	2000	2023-12-15 08:56:17.018388+01
d05e0f88-1e45-4b76-8350-81f51a940391	360-c6a-20b	701-a8c-d80	trissiti19	302f5e97-684f-4c64-9c30-998d985dba21	42fbae29-e9ba-4160-b797-f90ce5ebca88	dars	1000.00	1	1000	2023-12-15 09:51:00.561099+01
c5b60111-7ee9-4d90-a483-a9eae5ebd0dd	360-c6a-20b	701-a8c-d80	trissiti19	960d83c1-dcf4-4235-87c9-b211a25f4b35	42fbae29-e9ba-4160-b797-f90ce5ebca88	dars	1000.00	2	2000	2023-12-15 10:00:38.599588+01
548c3ba9-fa8f-4c8a-81b0-f0a9cc98be28	360-c6a-20b	701-a8c-d80	trissiti19	896d2da1-360e-41be-b3ca-ce242acbe20b	42fbae29-e9ba-4160-b797-f90ce5ebca88	dars	1000.00	1	1000	2023-12-15 12:50:53.337418+01
1b46b763-322f-48e4-b2eb-c1a980203629	360-c6a-20b	701-a8c-d80	trissiti19	d8f1df82-4897-4be0-af24-cb1eb75c5e88	42fbae29-e9ba-4160-b797-f90ce5ebca88	isam el-dars	1000.00	1	1000	2023-12-16 11:10:04.468517+01
b9432db4-dbdc-439e-a82d-a3e6d03675c3	360-c6a-20b	701-a8c-d80	trissiti19	d8f1df82-4897-4be0-af24-cb1eb75c5e88	42fbae29-e9ba-4160-b797-f90ce5ebca88	isam el-dars	1000.00	2	2000	2023-12-16 11:44:09.223682+01
\.


--
-- TOC entry 3390 (class 0 OID 16961)
-- Dependencies: 216
-- Data for Name: schools; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schools (code, name, email, created_at, license_end) FROM stdin;
360-c6a-20b	Laziri	\N	2023-11-01 18:12:20.55803+01	2023-12-01 18:12:20.55803+01
ef9-45b-c74	el mokhtabar	\N	2023-12-03 21:18:41.168418+01	2024-01-02 21:18:41.168418+01
d3b-109-f0e	' drop table schools --	\N	2023-12-14 18:33:10.907657+01	2024-01-13 18:33:10.907657+01
2c2-62b-789	` drop table schools --	\N	2023-12-14 18:33:34.511582+01	2024-01-13 18:33:34.511582+01
eb8-0df-743	${' drop table schools --}	\N	2023-12-14 18:33:51.879549+01	2024-01-13 18:33:51.879549+01
\.


--
-- TOC entry 3393 (class 0 OID 16992)
-- Dependencies: 219
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (uid, name, birthday, email, phone, school, created_at) FROM stdin;
ec46e986-d740-453a-a3ed-addb0d813950	Ahmed	2002-05-10	ahmed@email.com	05329837007	360-c6a-20b	2023-12-01 08:01:03.633286+01
881724d8-1866-4438-90a3-17432e2717dd	Mohammed	2005-02-26	mohammed@email.com	06501597242	360-c6a-20b	2023-12-01 08:01:03.633286+01
9b08f081-7db0-4344-bda2-4e7fcbe201ac	Fatima	2001-10-24	fatima@email.com	07380536167	360-c6a-20b	2023-12-01 08:01:03.633286+01
39f15d48-5ab9-4b83-ada1-48d5bdcbaea4	Amina	2002-08-15	amina@email.com	\N	360-c6a-20b	2023-12-01 08:01:03.633286+01
97849d39-648b-419e-8dae-a7df061922f3	Youssef	2001-05-18	youssef@email.com	\N	360-c6a-20b	2023-12-01 08:01:03.633286+01
3d200f7c-fb7e-487d-9158-c719c05b2127	Noor	2004-03-23	noor@email.com	\N	360-c6a-20b	2023-12-01 08:01:03.633286+01
130ec73c-a7b2-4244-ba61-f463e7d6d9e7	Laziri Amar	2002-11-18	trissiti19@gmail.com	+213698467691	360-c6a-20b	2023-11-29 18:29:33.164889+01
960d83c1-dcf4-4235-87c9-b211a25f4b35	Amar Laziri	2002-11-18	laziriamar100@gmail.com	0698467691	360-c6a-20b	2023-11-29 19:10:05.629483+01
48a0dba3-a8f1-4133-a587-40ab81d9c2a9	Ahmed Salah	2000-12-15	ahmed@email.com	0501234567	360-c6a-20b	2023-12-01 07:45:34.199835+01
1f3e18fd-e75b-436b-b728-425817aee616	Ahmed	2001-09-01	ahmed@email.com	05832641361	360-c6a-20b	2023-12-01 07:59:14.757312+01
182aa506-3489-4f60-99fb-1ccf8cd87d24	Mohammed	2004-09-22	mohammed@email.com	06163400645	360-c6a-20b	2023-12-01 07:59:14.757312+01
5608e202-f565-4f86-935a-ad8f8ca94552	Fatima	2005-12-17	fatima@email.com	07304369435	360-c6a-20b	2023-12-01 07:59:14.757312+01
9afafdc9-9789-40aa-a55b-0c28c39cb664	Layla	2002-08-26	layla@email.com	\N	360-c6a-20b	2023-12-01 08:01:03.633286+01
5551346c-2195-4c7f-9902-cee6c580aaf8	Omar	2003-04-24	omar@email.com	\N	360-c6a-20b	2023-12-01 08:01:03.633286+01
158a1a61-3a15-424d-b6ab-9f754175cae5	Ali	2000-02-07	ali@email.com	\N	360-c6a-20b	2023-12-01 08:01:03.633286+01
4a67059f-7eef-48af-b4b0-f60059e7cb05	Sara	2000-02-28	sara@email.com	\N	360-c6a-20b	2023-12-01 08:01:03.633286+01
6dede2f1-4237-4f5c-9974-19833de80d5f	Ahmed	2004-04-05	\N	05003979259	360-c6a-20b	2023-12-01 08:02:48.203452+01
f9519dea-4766-4743-9f56-80061cccffc8	Mohammed	2003-05-04	\N	\N	360-c6a-20b	2023-12-01 08:02:48.203452+01
8b8f4dd4-2675-4cf4-9f20-95f627c55d72	Fatima	2001-03-02	\N	07339322283	360-c6a-20b	2023-12-01 08:02:48.203452+01
708fc643-6258-4fba-991b-705920dddd7c	Amina	2002-04-08	amina@email.com	\N	360-c6a-20b	2023-12-01 08:02:48.203452+01
4cd1ba53-71b4-4645-ad8c-068b6bfa5b82	Youssef	2004-05-27	\N	\N	360-c6a-20b	2023-12-01 08:02:48.203452+01
ef6f9cd3-0876-4eb7-823b-a14e833bc719	Noor	2003-03-19	noor@email.com	\N	360-c6a-20b	2023-12-01 08:02:48.203452+01
ddddd1aa-6083-401f-87b3-693079348b83	Layla	2002-06-10	\N	\N	360-c6a-20b	2023-12-01 08:02:48.203452+01
1681e521-1211-400a-a6e5-22ad6501e73b	Omar	2001-09-25	omar@email.com	\N	360-c6a-20b	2023-12-01 08:02:48.203452+01
82a90cc7-cfc5-4953-b4ff-4de9a56002c1	Ali	2001-09-21	\N	\N	360-c6a-20b	2023-12-01 08:02:48.203452+01
562812c0-b167-419d-a67d-624ba5aea88d	Sara	2001-12-18	\N	\N	360-c6a-20b	2023-12-01 08:02:48.203452+01
ff5874eb-4ca8-4b50-8b3f-f49132ee5b8b	Ahmed	2005-09-14	ahmed@email.com	05114187161	360-c6a-20b	2023-12-01 08:02:55.90542+01
90307829-2ae4-48ef-ade9-4fcce56546f6	Mohammed	2003-09-04	mohammed@email.com	06616062496	360-c6a-20b	2023-12-01 08:02:55.90542+01
96062c99-ef11-4073-af8f-9d1da67a67c2	Fatima	2000-11-07	fatima@email.com	07467191674	360-c6a-20b	2023-12-01 08:02:55.90542+01
bb0428e9-ff6c-490b-bc70-d916a3cce8a1	Amina	2005-08-26	amina@email.com	\N	360-c6a-20b	2023-12-01 08:02:55.90542+01
5b47572d-9029-44fe-8a71-b74ca2e8c26b	Youssef	2000-09-26	youssef@email.com	\N	360-c6a-20b	2023-12-01 08:02:55.90542+01
27eda567-3a30-4652-bf47-d413952b3f57	Noor	2002-05-10	noor@email.com	\N	360-c6a-20b	2023-12-01 08:02:55.90542+01
be033000-9451-4b2d-a3e9-f135d709f10e	Layla	2001-07-23	layla@email.com	\N	360-c6a-20b	2023-12-01 08:02:55.90542+01
79030ed1-8b9d-4883-82cf-2199b43b34c2	Omar	2002-10-28	omar@email.com	\N	360-c6a-20b	2023-12-01 08:02:55.90542+01
f7e5db35-ca27-4276-bc0a-95b8349650fb	Ali	2001-08-12	ali@email.com	\N	360-c6a-20b	2023-12-01 08:02:55.90542+01
94eed853-84bd-465c-82bc-67c130805f33	Sara	2000-07-04	sara@email.com	\N	360-c6a-20b	2023-12-01 08:02:55.90542+01
24af4cb9-5c70-4842-9b33-4e2a3ae0eb78	Ahmed	2001-10-08	ahmed@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
479efd5f-7a43-460e-9e3f-c493708f63b2	Mohammed	2003-04-20	mohammed@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
0cf812ea-8372-45c7-85cc-02eff62bc079	Fatima	2005-10-18	fatima@email.com	07942439315	360-c6a-20b	2023-12-01 08:06:04.664964+01
c18d2eda-90d9-4dc9-8284-951c38e7a9a0	Amina	2005-02-23	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
50051adf-3823-4421-82b6-5855269a6cae	Youssef	2004-05-27	youssef@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
f63ea4e1-dad7-492d-ae56-c0ac624978e0	Noor	2002-11-23	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
896d2da1-360e-41be-b3ca-ce242acbe20b	Layla	2001-03-06	layla@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
c940f954-a47d-4654-9e78-a05cb6c11de8	Omar	2004-01-03	omar@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
09f8dabe-9bfb-482e-9890-680fafce1e65	Ali	2001-04-18	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
49c186af-3c01-489b-a432-cf7f47c1896c	Sara	2002-07-24	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
ab474898-6d44-45fa-925d-ffa7c836593b	Hassan	2002-06-26	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
119ae0e7-70c7-4c17-82ca-e1907cd14465	Aisha	2002-01-27	aisha@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
d8f1df82-4897-4be0-af24-cb1eb75c5e88	Khaled	2001-02-24	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
3aa27618-45c7-4daf-bfdf-4285f0c336f2	Lina	2002-12-14	lina@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
302f5e97-684f-4c64-9c30-998d985dba21	Tariq	2004-12-20	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
f8d1bb77-240f-46c7-a549-26a26e9ed269	Noura	2001-03-26	noura@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
e1b7ac51-5113-4f1a-92bb-89c4be479726	Ziad	2004-06-28	ziad@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
93e76b3a-8f8a-4a06-bf80-7c761a884de8	Yara	2003-05-20	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
6c0c3b58-368a-484a-a274-39014529c0f7	Karim	2000-04-08	karim@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
d6c9fbcb-c16c-4d4f-ae93-17b988048028	Rana	2003-04-28	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
03eb84c0-cd11-4c37-8fbb-cb666c6f4526	Bilal	2005-04-02	bilal@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
f49cfd19-9bb1-45fe-ba22-4dc70f06f9a8	Mona	2003-06-28	mona@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
c5b96c1d-4827-4ebe-a78b-2ced95fa897e	Samir	2000-07-23	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
5b2b0341-64ac-4cbc-8667-eeab29d7c42c	Rima	2000-11-15	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
ecea3dfc-3b0d-4c96-be82-400595ff304a	Nabil	2004-01-15	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
ba86911e-aa74-460e-be7b-057cec0f6cb3	Leila	2005-01-04	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
2cd8f2a0-8818-4769-875f-8debd1c5a952	Farid	2000-03-05	farid@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
0ef0f27a-8818-4dfc-9558-54b1957e4def	Rania	2002-04-19	rania@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
8c53d3bd-2313-470d-8ba2-34edec0324e3	Adel	2005-01-28	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
d411203c-fc63-4639-9ef9-8dbcfb5d05f7	Dina	2003-01-12	dina@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
5d32880c-d145-4cc9-bd3a-b841f4fa3863	Omar	2004-07-14	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
42efbd1d-8bba-48ba-ab1e-78e9e3441530	Amina	2005-12-27	amina@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
b13d2cba-9005-4951-b7ed-be4748c0f721	Rami	2002-12-24	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
61862565-b20d-4a54-bc74-ce8f5d0caab2	Samar	2004-08-08	samar@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
58951dd5-9719-4346-8d04-141a3ff569c0	Walid	2000-10-28	walid@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
62215883-390b-4fb0-a51b-f89e33b2e9aa	Nadia	2002-06-16	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
c7702bac-2cc8-4e9d-bb1d-e29d8d9539d8	Mazen	2001-07-27	mazen@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
ba1df8fb-7cde-4b5f-ab56-c6b25451a593	Maya	2001-11-17	maya@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
deecef20-d62c-4b34-b0d7-6cc00ac9821a	Zakaria	2002-02-26	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
d038aeb1-98c2-41a5-ab02-793d1d51f643	Hoda	2001-05-05	hoda@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
248487ec-f55a-43a6-b9ca-6c9af9739d09	Khalid	2000-04-11	khalid@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
28d2b79d-e79d-4c7d-a43d-93e8b5e01685	Nour	2003-10-23	nour@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
32ee401b-f834-4c42-ba2f-2cd0c1012b71	Hussein	2003-10-16	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
852c513c-c9ca-4167-a665-ee7c86a3b910	Jasmine	2003-06-23	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
fb0269ad-bc6b-44fc-9c8b-16bd8048c81a	Sami	2001-03-07	sami@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
c7f8d067-7024-48d4-8ee4-97b900024245	Hala	2002-06-22	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
b4dfa5bb-e20c-4c32-8ae3-438f91b0237d	Tamer	2002-01-06	tamer@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
0bf14308-fd7c-40fa-988d-ac102af5e08a	Yasmin	2002-10-17	yasmin@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
589c71f9-1b19-49db-94b1-6139cd12839c	Mahmoud	2003-03-04	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
afc16fb6-f041-4859-953f-ae22ebdf531e	Rasha	2001-10-20	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
a63da6ae-d261-4182-83c2-2dc71620c761	Tarek	2004-08-07	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
7f96de68-2d67-4bdb-b09f-a6ad2b01fe71	Rana	2003-04-07	rana@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
63522c80-a82e-45df-9185-5b6d1d617ebe	Mustafa	2003-03-23	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
141f13c9-fcdd-4db3-8796-a338ec177acd	Laila	2002-07-10	laila@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
bfb2a1bd-a4fc-4684-b045-e6596e430de4	Wael	2003-12-17	wael@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
8baffb01-e169-48ce-99d2-ba5a086d4441	Amal	2003-05-06	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
d8e39b01-4ff9-4a53-96af-a397bdca1ee3	Ali	2004-03-04	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
309d21b5-9364-4d9d-80c4-98787c174a3b	Lina	2001-08-12	lina@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
b9b08214-665d-4bb4-8b55-925ab7e93989	Karim	2005-04-11	karim@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
c0238942-73e5-4482-b0c4-6e9ea1af1cd3	Layla	2001-08-12	layla@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
56794175-0197-41d9-b1ba-debadba09ba4	Adnan	2005-12-22	adnan@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
f4879ddd-da21-48eb-aa80-06ff99b56eb8	Salma	2000-11-03	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
3362915c-952e-411b-b805-fac8e2b101bf	Riad	2004-05-12	riad@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
9f7aa900-b6ae-49b2-ae5c-6714d30c8a81	Maha	2005-12-18	maha@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
0f71c8a9-9b14-4866-aec5-26eaba5a0d45	Hamza	2003-04-22	hamza@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
4a6d5ddb-2fbd-48bd-bb1c-43fa94761313	Dina	2001-01-14	dina@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
415b452b-99cc-4fdf-bfff-cf52b2986d7f	Kamal	2001-08-11	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
9259d42e-dc37-416d-9026-6648c39b258d	Soraya	2004-05-01	soraya@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
c2be3318-1783-4e88-82d8-1b790c731664	Raed	2005-04-17	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
69622939-0759-4161-af12-5a4083d6cb4e	Mai	2003-07-09	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
ff278095-2773-4963-8c57-4ea0e4c1977b	Fadi	2001-03-16	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
31859cad-06c5-48e5-bf1c-4fdeccf840b2	Lina	2004-12-06	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
433fbc72-e8ce-4080-b5e5-679642549f0f	Imad	2002-12-07	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
58fa19d2-ae11-4f28-8b44-2ff79e2f5f5c	Sawsan	2002-03-05	sawsan@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
b4e7ae88-7224-42d6-9639-93c52c0d70cc	Fares	2002-03-11	fares@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
0ad1404d-443d-4044-8bf7-f18233fe9113	Samar	2001-09-25	samar@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
70397b7a-9639-4f37-bc2c-89cddf93b276	Nader	2000-04-19	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
ad75b6b5-bb1f-4354-8ff2-dd4799499720	Reem	2005-03-01	reem@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
d11deb77-c001-4086-9f7e-db3b120f601c	Wael	2002-01-11	wael@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
777466f7-e86e-40f7-b8a8-9c998fc54078	Dalia	2005-01-21	dalia@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
feb356f4-f821-4821-af5b-b03f0dc9fff2	Zakariya	2003-11-28	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
667f812c-d6a2-4897-93b8-041d7060befa	Inas	2001-11-19	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
953fc101-37bc-43ab-a747-ebb37be94fce	Rafik	2003-01-26	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
daf5d53a-b6c7-4e24-9523-5fe8982a1c18	Nina	2005-02-24	nina@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
e1886601-570a-4983-8403-b6422c571206	Maher	2001-01-11	maher@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
d165bfeb-c980-4f1b-8375-19e6de6319d4	Leila	2002-10-05	leila@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
673e7d7a-3a34-4640-95e0-89929577a88c	Rami	2000-03-20	rami@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
7856f5d3-b7f2-4750-960f-d47f047d7c48	Nadia	2003-12-04	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
fd1130f8-0880-4c0b-b87e-36104c0ca5ea	Yassin	2004-04-04	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
1ee282e1-ccee-47ec-b123-46ab4556e3af	Rima	2001-10-11	rima@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
af8fe744-a420-4ff6-a8db-e3fe1acd78c7	Ahmad	2004-04-26	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
c58ba4c3-93e2-4f4c-9141-2464d5cbddf9	Rasha	2000-02-20	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
24fee35d-7e2b-42c1-9bb9-0511a4e9ee2c	Khaled	2001-09-27	\N	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
39eb8815-40fb-4f3b-a2a4-83ec8b7164f5	Noura	2000-12-21	noura@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
f00ee94f-05cb-4327-bc37-e7ee0f401e81	Amr	2001-02-19	amr@email.com	\N	360-c6a-20b	2023-12-01 08:06:04.664964+01
25511ca4-bb25-4238-9531-90c4ea577c6a	test student	2002-12-01	test@mail.com	\N	ef9-45b-c74	2023-12-03 21:19:53.531937+01
1a969eb1-ace7-49a7-ae22-29dbc62ac33f	Ahmed Salah	2000-10-11	\N	\N	d3b-109-f0e	2023-12-14 18:42:42.911477+01
\.


--
-- TOC entry 3389 (class 0 OID 16950)
-- Dependencies: 215
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (code, email, password, created_at) FROM stdin;
701-a8c-d80	trissiti19@gmail.com	$2b$10$1wV9DvyCr7.tnK.Lmv2Vve3UO4w2L82kvUdRRiwMzNzBvqRlXurQm	2023-11-01 18:03:08.968546+01
3d4-6c3-f21	laziri.bmlab@gmail.com	$2b$10$pPRdh6SsReyv1ZnF6ZU5vOYzYHkiVHWqGrx4ITNWJgRKMdKOUqNXS	2023-11-01 19:26:58.846148+01
991-15c-c2f	laziriamar100@gmail.com	$2b$10$NMeZZsQ0ly0nGOiQPJMDBexSsc2vFGUtyviEIvp91pr/zT6J3XDZa	2023-12-03 21:18:15.733979+01
\.


--
-- TOC entry 3391 (class 0 OID 16971)
-- Dependencies: 217
-- Data for Name: users_schools; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_schools (user_code, school_code, role, status, created_at) FROM stdin;
701-a8c-d80	360-c6a-20b	owner	active	2023-11-01 18:12:20.577918+01
991-15c-c2f	ef9-45b-c74	owner	active	2023-12-03 21:18:41.172241+01
701-a8c-d80	d3b-109-f0e	owner	active	2023-12-14 18:33:10.931923+01
701-a8c-d80	2c2-62b-789	owner	active	2023-12-14 18:33:34.514863+01
701-a8c-d80	eb8-0df-743	owner	active	2023-12-14 18:33:51.884176+01
\.


--
-- TOC entry 3232 (class 2606 OID 16986)
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (uid);


--
-- TOC entry 3238 (class 2606 OID 17259)
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (uid);


--
-- TOC entry 3236 (class 2606 OID 17147)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (uid);


--
-- TOC entry 3228 (class 2606 OID 16970)
-- Name: schools schools_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (code);


--
-- TOC entry 3234 (class 2606 OID 16999)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (uid);


--
-- TOC entry 3224 (class 2606 OID 16960)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3226 (class 2606 OID 16958)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (code);


--
-- TOC entry 3230 (class 2606 OID 16978)
-- Name: users_schools users_schools_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_schools
    ADD CONSTRAINT users_schools_pkey PRIMARY KEY (user_code, school_code);


--
-- TOC entry 3239 (class 2606 OID 16987)
-- Name: courses courses_school_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code) ON DELETE CASCADE;


--
-- TOC entry 3245 (class 2606 OID 17265)
-- Name: lessons lessons_course_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_course_fkey FOREIGN KEY (course) REFERENCES public.courses(uid);


--
-- TOC entry 3246 (class 2606 OID 17260)
-- Name: lessons lessons_school_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code);


--
-- TOC entry 3241 (class 2606 OID 17163)
-- Name: payments payments_course_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_course_fkey FOREIGN KEY (course) REFERENCES public.courses(uid);


--
-- TOC entry 3242 (class 2606 OID 17148)
-- Name: payments payments_school_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code);


--
-- TOC entry 3243 (class 2606 OID 17158)
-- Name: payments payments_student_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_student_fkey FOREIGN KEY (student) REFERENCES public.students(uid);


--
-- TOC entry 3244 (class 2606 OID 17153)
-- Name: payments payments_user_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_user_code_fkey FOREIGN KEY (user_code) REFERENCES public.users(code);


--
-- TOC entry 3240 (class 2606 OID 17000)
-- Name: students students_school_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code) ON DELETE CASCADE;


-- Completed on 2023-12-19 12:27:22

--
-- PostgreSQL database dump complete
--

-- Completed on 2023-12-19 12:27:22

--
-- PostgreSQL database cluster dump complete
--

