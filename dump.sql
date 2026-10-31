--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: album; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.album (
    id integer NOT NULL,
    naziv text NOT NULL,
    godina integer,
    jezik text NOT NULL,
    ocjena numeric(3,1),
    izvodac_id integer NOT NULL,
    CONSTRAINT album_ocjena_check CHECK (((ocjena >= (0)::numeric) AND (ocjena <= (10)::numeric)))
);


ALTER TABLE public.album OWNER TO postgres;

--
-- Name: album_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.album_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.album_id_seq OWNER TO postgres;

--
-- Name: album_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.album_id_seq OWNED BY public.album.id;


--
-- Name: album_zanr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.album_zanr (
    album_id integer NOT NULL,
    zanr_id integer NOT NULL
);


ALTER TABLE public.album_zanr OWNER TO postgres;

--
-- Name: izvodac; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.izvodac (
    id integer NOT NULL,
    ime text NOT NULL,
    drzava text NOT NULL,
    godina_osnutka integer
);


ALTER TABLE public.izvodac OWNER TO postgres;

--
-- Name: izvodac_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.izvodac_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.izvodac_id_seq OWNER TO postgres;

--
-- Name: izvodac_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.izvodac_id_seq OWNED BY public.izvodac.id;


--
-- Name: pjesma; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pjesma (
    id integer NOT NULL,
    album_id integer NOT NULL,
    redni_broj integer NOT NULL,
    naslov text NOT NULL,
    trajanje_s integer NOT NULL,
    CONSTRAINT pjesma_trajanje_s_check CHECK ((trajanje_s > 0))
);


ALTER TABLE public.pjesma OWNER TO postgres;

--
-- Name: pjesma_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pjesma_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pjesma_id_seq OWNER TO postgres;

--
-- Name: pjesma_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pjesma_id_seq OWNED BY public.pjesma.id;


--
-- Name: zanr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zanr (
    id integer NOT NULL,
    naziv text NOT NULL
);


ALTER TABLE public.zanr OWNER TO postgres;

--
-- Name: v_albumi_csv; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_albumi_csv AS
 SELECT a.id AS album_id,
    a.naziv AS naziv_albuma,
    a.godina,
    a.jezik,
    a.ocjena,
    i.ime AS izvodac,
    i.drzava AS drzava_izvodaca,
    i.godina_osnutka AS godina_osnutka_izvodaca,
    ( SELECT string_agg(z.naziv, '; '::text ORDER BY z.naziv) AS string_agg
           FROM (public.album_zanr az
             JOIN public.zanr z ON ((z.id = az.zanr_id)))
          WHERE (az.album_id = a.id)) AS zanrovi,
    p.redni_broj AS redni_broj_pjesme,
    p.naslov AS naslov_pjesme,
    p.trajanje_s AS trajanje_pjesme_s
   FROM ((public.album a
     JOIN public.izvodac i ON ((i.id = a.izvodac_id)))
     JOIN public.pjesma p ON ((p.album_id = a.id)))
  ORDER BY a.id, p.redni_broj;


ALTER VIEW public.v_albumi_csv OWNER TO postgres;

--
-- Name: zanr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.zanr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.zanr_id_seq OWNER TO postgres;

--
-- Name: zanr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.zanr_id_seq OWNED BY public.zanr.id;


--
-- Name: album id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album ALTER COLUMN id SET DEFAULT nextval('public.album_id_seq'::regclass);


--
-- Name: izvodac id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.izvodac ALTER COLUMN id SET DEFAULT nextval('public.izvodac_id_seq'::regclass);


--
-- Name: pjesma id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pjesma ALTER COLUMN id SET DEFAULT nextval('public.pjesma_id_seq'::regclass);


--
-- Name: zanr id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zanr ALTER COLUMN id SET DEFAULT nextval('public.zanr_id_seq'::regclass);


--
-- Data for Name: album; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.album (id, naziv, godina, jezik, ocjena, izvodac_id) FROM stdin;
1	Waterloo	1974	engleski	7.5	1
2	Voulez-Vous	1979	engleski	10.0	1
3	Catching Rays on Giant	2010	engleski	8.2	2
4	Look Sharp	1988	engleski	8.0	3
5	Joyride	1991	engleski	7.3	3
6	Ljubavna pjesma	1975	hrvatski	7.2	4
7	Anđeli se dosađuju?	1987	hrvatski	6.0	5
8	Faith	1987	engleski	8.6	6
9	Voyage	2021	engleski	4.8	1
10	Forever Young	1984	engleski	6.0	2
\.


--
-- Data for Name: album_zanr; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.album_zanr (album_id, zanr_id) FROM stdin;
1	1
1	2
2	1
2	3
3	1
4	1
4	2
5	1
5	2
6	4
7	1
7	2
8	1
8	2
8	5
9	1
9	3
10	1
\.


--
-- Data for Name: izvodac; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.izvodac (id, ime, drzava, godina_osnutka) FROM stdin;
1	ABBA	Švedska	1972
2	Alphaville	Njemačka	1982
3	Roxette	Švedska	1986
4	Oliver Dragojević	Hrvatska	1974
5	Parni valjak	Hrvatska	1975
6	George Michael	Ujedinjeno Kraljevstvo	1982
\.


--
-- Data for Name: pjesma; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pjesma (id, album_id, redni_broj, naslov, trajanje_s) FROM stdin;
1	1	1	Waterloo	164
2	1	2	Sitting in the Palmtree	217
3	1	3	King Kong Song	191
4	1	4	Hasta Mañana	189
5	1	5	My Mama Said	193
6	1	6	Dance (While the Music Still Goes On)	192
7	1	7	Honey, Honey	175
8	1	8	Watch Out	229
9	1	9	What About Livingstone?	175
10	1	10	Gonna Sing You My Lovesong	221
11	1	11	Suzy-Hang-Around	190
12	2	1	As Good as New	204
13	2	2	Voulez-Vous	309
14	2	3	I Have a Dream	285
15	2	4	Angeleyes	260
16	2	5	The King Has Lost His Crown	212
17	2	6	Does Your Mother Know	193
18	2	7	If It Wasn't for the Nights	309
19	2	8	Chiquitita	326
20	2	9	Lovers (Live a Little Longer)	210
21	2	10	Kisses of Fire	196
22	3	1	Song for No One	212
23	3	2	I Die for You Today	227
24	3	3	End of the World	239
25	3	4	The Things I Didn't Do	280
26	3	5	Heaven on Earth (The Things We've Got to Do)	285
27	3	6	The Deep	263
28	3	7	Call Me	227
29	3	8	Gravitation Breakdown	255
30	3	9	Carry Your Flag	293
31	3	10	Call Me Down	271
32	3	11	Phantoms	219
33	3	12	Miracle Healing	304
34	4	1	The Look	237
35	4	2	Dressed for Success	249
36	4	3	Sleeping Single	278
37	4	4	Paint	210
38	4	5	Dance Away	205
39	4	6	Cry	319
40	4	7	Chances	297
41	4	8	Dangerous	228
42	4	9	Half a Woman, Half a Shadow	215
43	4	10	View from a Hill	220
44	4	11	Shadow of a Doubt	254
45	4	12	Listen to Your Heart	328
46	5	1	Joyride	264
47	5	2	Hotblooded	198
48	5	3	Fading Like a Flower (Every Time You Leave)	232
49	5	4	Knockin' on Every Door	236
50	5	5	Spending My Time	276
51	5	6	I Remember You	234
52	5	7	Watercolours in the Rain	220
53	5	8	The Big L.	266
54	5	9	Soul Deep	214
55	5	10	(Do You Get) Excited?	256
56	5	11	Church of Your Heart	196
57	5	12	Small Talk	233
58	5	13	Physical Fascination	207
59	5	14	Things Will Never Be the Same	266
60	5	15	Perfect Day	245
61	6	1	Ljubavna pjesma	243
62	6	2	Picaferaj	200
63	6	3	Djeca jednog vijeka	181
64	6	4	Bila je jesen	154
65	6	5	Ne žuri, djevojčice	291
66	6	6	Ksantipa	202
67	6	7	Meni trebaš ti	201
68	6	8	Prisjećam se noćas	134
69	6	9	Znam da me voliš	212
70	7	1	Anđeli se dosađuju?	221
71	7	2	Anja	211
72	7	3	Kada me dotakne	327
73	7	4	Navigator	219
74	7	5	Jesen u meni	270
75	7	6	Zagreb ima isti pozivni	231
76	7	7	Nova kola	288
77	7	8	Tvoji koraci	269
78	8	1	Faith	196
79	8	2	Father Figure	336
80	8	3	One More Try	350
81	8	4	Hard Day	288
82	8	5	Hand to Mouth	276
83	8	6	Look at Your Hands	277
84	8	7	Monkey	306
85	9	1	I Still Have Faith in You	308
86	9	2	When You Danced with Me	169
87	9	3	Little Things	188
88	9	4	Don't Shut Me Down	239
89	9	5	Just a Notion	209
90	9	6	I Can Be That Woman	244
91	9	7	Keep an Eye on Dan	241
92	9	8	Bumblebee	237
93	9	9	No Doubt About It	172
94	9	10	Ode to Freedom	211
95	10	1	A Victory of Love	254
96	10	2	Summer in Berlin	282
97	10	3	Big in Japan	280
98	10	4	To Germany with Love	255
99	10	5	Fallen Angel	235
100	10	6	Forever Young	225
101	10	7	In the Mood	269
102	10	8	Sounds Like a Melody	282
103	10	9	Lies	212
104	10	10	The Jet Set	292
\.


--
-- Data for Name: zanr; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zanr (id, naziv) FROM stdin;
1	Pop
2	Rock
3	Disco
4	Zabavna glazba
5	Funk
\.


--
-- Name: album_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.album_id_seq', 10, true);


--
-- Name: izvodac_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.izvodac_id_seq', 6, true);


--
-- Name: pjesma_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pjesma_id_seq', 104, true);


--
-- Name: zanr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.zanr_id_seq', 5, true);


--
-- Name: album album_naziv_izvodac_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_naziv_izvodac_id_key UNIQUE (naziv, izvodac_id);


--
-- Name: album album_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_pkey PRIMARY KEY (id);


--
-- Name: album_zanr album_zanr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album_zanr
    ADD CONSTRAINT album_zanr_pkey PRIMARY KEY (album_id, zanr_id);


--
-- Name: izvodac izvodac_ime_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.izvodac
    ADD CONSTRAINT izvodac_ime_key UNIQUE (ime);


--
-- Name: izvodac izvodac_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.izvodac
    ADD CONSTRAINT izvodac_pkey PRIMARY KEY (id);


--
-- Name: pjesma pjesma_album_id_redni_broj_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pjesma
    ADD CONSTRAINT pjesma_album_id_redni_broj_key UNIQUE (album_id, redni_broj);


--
-- Name: pjesma pjesma_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pjesma
    ADD CONSTRAINT pjesma_pkey PRIMARY KEY (id);


--
-- Name: zanr zanr_naziv_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zanr
    ADD CONSTRAINT zanr_naziv_key UNIQUE (naziv);


--
-- Name: zanr zanr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zanr
    ADD CONSTRAINT zanr_pkey PRIMARY KEY (id);


--
-- Name: album album_izvodac_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_izvodac_id_fkey FOREIGN KEY (izvodac_id) REFERENCES public.izvodac(id);


--
-- Name: album_zanr album_zanr_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album_zanr
    ADD CONSTRAINT album_zanr_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(id) ON DELETE CASCADE;


--
-- Name: album_zanr album_zanr_zanr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album_zanr
    ADD CONSTRAINT album_zanr_zanr_id_fkey FOREIGN KEY (zanr_id) REFERENCES public.zanr(id);


--
-- Name: pjesma pjesma_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pjesma
    ADD CONSTRAINT pjesma_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

