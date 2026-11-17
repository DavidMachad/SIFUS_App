--
-- PostgreSQL database dump
--


-- Dumped from database version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)

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
-- Name: AccessPurpose; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AccessPurpose" AS ENUM (
    'CLINICAL_REPORT',
    'CRISIS_RESPONSE',
    'ACCOUNT_RECOVERY',
    'DATA_SUBJECT_REQUEST',
    'LEGAL_OBLIGATION'
);


--
-- Name: DocumentType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."DocumentType" AS ENUM (
    'CC',
    'TI',
    'CE',
    'PASSPORT',
    'PPT'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Name: guardians; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guardians (
    id text NOT NULL,
    "subjectId" text NOT NULL,
    "fullNameCiphertext" text NOT NULL,
    "documentCiphertext" text NOT NULL,
    "phoneCiphertext" text NOT NULL,
    relationship text NOT NULL
);


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identities (
    "subjectId" text NOT NULL,
    "emailBlindIndex" text NOT NULL,
    "emailCiphertext" text NOT NULL,
    "fullNameCiphertext" text NOT NULL,
    "documentType" public."DocumentType",
    "documentBlindIndex" text,
    "documentCiphertext" text,
    "phoneCiphertext" text,
    "birthDateCiphertext" text NOT NULL,
    "keyVersion" integer DEFAULT 1 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "erasedAt" timestamp(3) without time zone
);


--
-- Name: identity_access_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identity_access_log (
    id text NOT NULL,
    "subjectId" text NOT NULL,
    "accessedBy" text NOT NULL,
    purpose public."AccessPurpose" NOT NULL,
    "justificationRef" text,
    "accessedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
558f834b-6f03-4104-8070-2b0511ca89d8	e773eeecf4687c6aa697c2eacfc702550730708733d4f629fdd272b671f21827	2026-11-16 20:18:29.916346+00	20261027134310_init	\N	\N	2026-11-16 20:18:29.907901+00	1
\.


--
-- Data for Name: guardians; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guardians (id, "subjectId", "fullNameCiphertext", "documentCiphertext", "phoneCiphertext", relationship) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.identities ("subjectId", "emailBlindIndex", "emailCiphertext", "fullNameCiphertext", "documentType", "documentBlindIndex", "documentCiphertext", "phoneCiphertext", "birthDateCiphertext", "keyVersion", "createdAt", "updatedAt", "erasedAt") FROM stdin;
\.


--
-- Data for Name: identity_access_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.identity_access_log (id, "subjectId", "accessedBy", purpose, "justificationRef", "accessedAt") FROM stdin;
\.


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: guardians guardians_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guardians
    ADD CONSTRAINT guardians_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY ("subjectId");


--
-- Name: identity_access_log identity_access_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_access_log
    ADD CONSTRAINT identity_access_log_pkey PRIMARY KEY (id);


--
-- Name: guardians_subjectId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "guardians_subjectId_key" ON public.guardians USING btree ("subjectId");


--
-- Name: identities_documentBlindIndex_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "identities_documentBlindIndex_key" ON public.identities USING btree ("documentBlindIndex");


--
-- Name: identities_emailBlindIndex_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "identities_emailBlindIndex_key" ON public.identities USING btree ("emailBlindIndex");


--
-- Name: identity_access_log_subjectId_accessedAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "identity_access_log_subjectId_accessedAt_idx" ON public.identity_access_log USING btree ("subjectId", "accessedAt");


--
-- Name: guardians guardians_subjectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guardians
    ADD CONSTRAINT "guardians_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES public.identities("subjectId") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: identity_access_log identity_access_log_subjectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identity_access_log
    ADD CONSTRAINT "identity_access_log_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES public.identities("subjectId") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--


