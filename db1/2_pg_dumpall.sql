--
-- PostgreSQL database cluster dump
--

-- Started on 2022-03-25 16:05:04 UTC

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

ALTER ROLE grafana WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
ALTER ROLE pgbench WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;


--
-- Role memberships
--

GRANT pg_monitor TO grafana GRANTED BY postgres;




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

-- Dumped from database version 14.2 (Debian 14.2-1.pgdg110+1)
-- Dumped by pg_dump version 14.2

-- Started on 2022-03-25 16:05:04 UTC

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
-- TOC entry 2 (class 3079 OID 25025)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- TOC entry 3320 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


-- Completed on 2022-03-25 16:05:05 UTC

--
-- PostgreSQL database dump complete
--

--
-- Database "grafana" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Debian 14.2-1.pgdg110+1)
-- Dumped by pg_dump version 14.2

-- Started on 2022-03-25 16:05:05 UTC

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
-- TOC entry 3353 (class 1262 OID 16386)
-- Name: grafana; Type: DATABASE; Schema: -; Owner: grafana
--

CREATE DATABASE grafana WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE grafana OWNER TO grafana;

\connect grafana

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
-- TOC entry 7 (class 2615 OID 16387)
-- Name: pglogs; Type: SCHEMA; Schema: -; Owner: grafana
--

CREATE SCHEMA pglogs;


ALTER SCHEMA pglogs OWNER TO grafana;

--
-- TOC entry 6 (class 2615 OID 16388)
-- Name: pgmetrics; Type: SCHEMA; Schema: -; Owner: grafana
--

CREATE SCHEMA pgmetrics;


ALTER SCHEMA pgmetrics OWNER TO grafana;

--
-- TOC entry 3 (class 3079 OID 16390)
-- Name: file_fdw; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS file_fdw WITH SCHEMA public;


--
-- TOC entry 3354 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION file_fdw; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION file_fdw IS 'foreign-data wrapper for flat file access';


--
-- TOC entry 2 (class 3079 OID 33242)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- TOC entry 3355 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- TOC entry 232 (class 1255 OID 16822)
-- Name: refresh_wal_metrics(); Type: PROCEDURE; Schema: pgmetrics; Owner: grafana
--

CREATE PROCEDURE pgmetrics.refresh_wal_metrics()
    LANGUAGE sql
    AS $$INSERT INTO pgmetrics.wal_metrics (
WITH jtr AS (
    SELECT
        id
        , metrics_raw -> 'wal' AS wal
    FROM
        pgmetrics.raw_metrics rm
	WHERE rm.collection_at > (select max(wm.collection_at) from pgmetrics.wal_metrics wm)
	OR rm.cluster_name not in (select DISTINCT wm.cluster_name from pgmetrics.wal_metrics wm)
)
SELECT
    rm.collection_at
    , rm.cluster_name
    , wal.*
FROM
    jtr
    LEFT JOIN pgmetrics.raw_metrics rm ON jtr.id = rm.id
    , LATERAL jsonb_to_record(jtr.wal) AS wal (fpi int
        , sync int
        , bytes int
        , write int
        , records int
        , sync_time int
        , write_time int
        , stats_reset int
        , buffers_full int)
);
$$;


ALTER PROCEDURE pgmetrics.refresh_wal_metrics() OWNER TO grafana;

--
-- TOC entry 2052 (class 1417 OID 16394)
-- Name: pglog_server; Type: SERVER; Schema: -; Owner: postgres
--

CREATE SERVER pglog_server FOREIGN DATA WRAPPER file_fdw;


ALTER SERVER pglog_server OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16395)
-- Name: raw_metrics_id_seq; Type: SEQUENCE; Schema: pgmetrics; Owner: grafana
--

CREATE SEQUENCE pgmetrics.raw_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    CYCLE;


ALTER TABLE pgmetrics.raw_metrics_id_seq OWNER TO grafana;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 16396)
-- Name: raw_metrics; Type: TABLE; Schema: pgmetrics; Owner: grafana
--

CREATE TABLE pgmetrics.raw_metrics (
    id integer DEFAULT nextval('pgmetrics.raw_metrics_id_seq'::regclass) NOT NULL,
    collection_at integer NOT NULL,
    metrics_raw jsonb NOT NULL,
    cluster_name text NOT NULL
);


ALTER TABLE pgmetrics.raw_metrics OWNER TO grafana;

--
-- TOC entry 3356 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN raw_metrics.cluster_name; Type: COMMENT; Schema: pgmetrics; Owner: grafana
--

COMMENT ON COLUMN pgmetrics.raw_metrics.cluster_name IS 'Arbitrary name of the host / database cluster where pgmetrics data is sourced from.';


--
-- TOC entry 215 (class 1259 OID 16715)
-- Name: wal_metrics; Type: TABLE; Schema: pgmetrics; Owner: grafana
--

CREATE TABLE pgmetrics.wal_metrics (
    collection_at integer NOT NULL,
    cluster_name text NOT NULL,
    fpi integer,
    sync integer,
    bytes integer,
    write integer,
    records integer,
    sync_time integer,
    write_time integer,
    stats_reset integer,
    buffers_full integer
)
PARTITION BY RANGE (collection_at);


ALTER TABLE pgmetrics.wal_metrics OWNER TO grafana;

--
-- TOC entry 216 (class 1259 OID 16737)
-- Name: wal_metrics_default; Type: TABLE; Schema: pgmetrics; Owner: grafana
--

CREATE TABLE pgmetrics.wal_metrics_default (
    collection_at integer NOT NULL,
    cluster_name text NOT NULL,
    fpi integer,
    sync integer,
    bytes integer,
    write integer,
    records integer,
    sync_time integer,
    write_time integer,
    stats_reset integer,
    buffers_full integer
);


ALTER TABLE pgmetrics.wal_metrics_default OWNER TO grafana;

--
-- TOC entry 3195 (class 0 OID 0)
-- Name: wal_metrics_default; Type: TABLE ATTACH; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.wal_metrics ATTACH PARTITION pgmetrics.wal_metrics_default DEFAULT;


--
-- TOC entry 3198 (class 2606 OID 16702)
-- Name: raw_metrics raw_metrics_collection_at_cluster_name_key; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.raw_metrics
    ADD CONSTRAINT raw_metrics_collection_at_cluster_name_key UNIQUE (collection_at, cluster_name);


--
-- TOC entry 3200 (class 2606 OID 16416)
-- Name: raw_metrics raw_metrics_pkey; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.raw_metrics
    ADD CONSTRAINT raw_metrics_pkey PRIMARY KEY (id);


--
-- TOC entry 3202 (class 2606 OID 16719)
-- Name: wal_metrics wal_metrics_pkey; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.wal_metrics
    ADD CONSTRAINT wal_metrics_pkey PRIMARY KEY (collection_at, cluster_name);


--
-- TOC entry 3204 (class 2606 OID 16741)
-- Name: wal_metrics_default wal_metrics_default_pkey; Type: CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE ONLY pgmetrics.wal_metrics_default
    ADD CONSTRAINT wal_metrics_default_pkey PRIMARY KEY (collection_at, cluster_name);


--
-- TOC entry 3205 (class 0 OID 0)
-- Name: wal_metrics_default_pkey; Type: INDEX ATTACH; Schema: pgmetrics; Owner: grafana
--

ALTER INDEX pgmetrics.wal_metrics_pkey ATTACH PARTITION pgmetrics.wal_metrics_default_pkey;


--
-- TOC entry 3206 (class 2606 OID 16720)
-- Name: wal_metrics wal_metrics_collection_at_cluster_name_fkey; Type: FK CONSTRAINT; Schema: pgmetrics; Owner: grafana
--

ALTER TABLE pgmetrics.wal_metrics
    ADD CONSTRAINT wal_metrics_collection_at_cluster_name_fkey FOREIGN KEY (collection_at, cluster_name) REFERENCES pgmetrics.raw_metrics(collection_at, cluster_name);


-- Completed on 2022-03-25 16:05:05 UTC

--
-- PostgreSQL database dump complete
--

--
-- Database "pgbench" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Debian 14.2-1.pgdg110+1)
-- Dumped by pg_dump version 14.2

-- Started on 2022-03-25 16:05:05 UTC

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
-- TOC entry 3342 (class 1262 OID 16419)
-- Name: pgbench; Type: DATABASE; Schema: -; Owner: pgbench
--

CREATE DATABASE pgbench WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE pgbench OWNER TO pgbench;

\connect pgbench

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
-- TOC entry 2 (class 3079 OID 33217)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- TOC entry 3343 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 212 (class 1259 OID 16603)
-- Name: pgbench_accounts; Type: TABLE; Schema: public; Owner: pgbench
--

CREATE TABLE public.pgbench_accounts (
    aid integer NOT NULL,
    bid integer,
    abalance integer,
    filler character(84)
)
WITH (fillfactor='100');


ALTER TABLE public.pgbench_accounts OWNER TO pgbench;

--
-- TOC entry 213 (class 1259 OID 16606)
-- Name: pgbench_branches; Type: TABLE; Schema: public; Owner: pgbench
--

CREATE TABLE public.pgbench_branches (
    bid integer NOT NULL,
    bbalance integer,
    filler character(88)
)
WITH (fillfactor='100');


ALTER TABLE public.pgbench_branches OWNER TO pgbench;

--
-- TOC entry 210 (class 1259 OID 16597)
-- Name: pgbench_history; Type: TABLE; Schema: public; Owner: pgbench
--

CREATE TABLE public.pgbench_history (
    tid integer,
    bid integer,
    aid integer,
    delta integer,
    mtime timestamp without time zone,
    filler character(22)
);


ALTER TABLE public.pgbench_history OWNER TO pgbench;

--
-- TOC entry 211 (class 1259 OID 16600)
-- Name: pgbench_tellers; Type: TABLE; Schema: public; Owner: pgbench
--

CREATE TABLE public.pgbench_tellers (
    tid integer NOT NULL,
    bid integer,
    tbalance integer,
    filler character(84)
)
WITH (fillfactor='100');


ALTER TABLE public.pgbench_tellers OWNER TO pgbench;

--
-- TOC entry 3193 (class 2606 OID 16618)
-- Name: pgbench_accounts pgbench_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: pgbench
--

ALTER TABLE ONLY public.pgbench_accounts
    ADD CONSTRAINT pgbench_accounts_pkey PRIMARY KEY (aid);


--
-- TOC entry 3195 (class 2606 OID 16614)
-- Name: pgbench_branches pgbench_branches_pkey; Type: CONSTRAINT; Schema: public; Owner: pgbench
--

ALTER TABLE ONLY public.pgbench_branches
    ADD CONSTRAINT pgbench_branches_pkey PRIMARY KEY (bid);


--
-- TOC entry 3191 (class 2606 OID 16616)
-- Name: pgbench_tellers pgbench_tellers_pkey; Type: CONSTRAINT; Schema: public; Owner: pgbench
--

ALTER TABLE ONLY public.pgbench_tellers
    ADD CONSTRAINT pgbench_tellers_pkey PRIMARY KEY (tid);


-- Completed on 2022-03-25 16:05:05 UTC

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Debian 14.2-1.pgdg110+1)
-- Dumped by pg_dump version 14.2

-- Started on 2022-03-25 16:05:05 UTC

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
-- TOC entry 10 (class 2615 OID 16438)
-- Name: pgagent; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgagent;


ALTER SCHEMA pgagent OWNER TO postgres;

--
-- TOC entry 3446 (class 0 OID 0)
-- Dependencies: 10
-- Name: SCHEMA pgagent; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';


--
-- TOC entry 4 (class 3079 OID 33287)
-- Name: pg_buffercache; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_buffercache WITH SCHEMA public;


--
-- TOC entry 3447 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pg_buffercache; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_buffercache IS 'examine the shared buffer cache';


--
-- TOC entry 2 (class 3079 OID 16439)
-- Name: pgagent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;


--
-- TOC entry 3448 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgagent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';


--
-- TOC entry 3 (class 3079 OID 33277)
-- Name: pgstattuple; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgstattuple WITH SCHEMA public;


--
-- TOC entry 3449 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pgstattuple; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgstattuple IS 'show tuple-level statistics';


-- Completed on 2022-03-25 16:05:05 UTC

--
-- PostgreSQL database dump complete
--

-- Completed on 2022-03-25 16:05:05 UTC

--
-- PostgreSQL database cluster dump complete
--

