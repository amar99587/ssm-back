--
-- PostgreSQL database cluster dump
--

-- Started on 2023-12-19 12:26:52

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








-- Completed on 2023-12-19 12:26:53

--
-- PostgreSQL database cluster dump complete
--

