--
-- PostgreSQL database dump
--

-- Dumped from database version 14.20 (Homebrew)
-- Dumped by pg_dump version 17.5

-- Started on 2025-12-02 14:52:04 MSK

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

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: leetcloud
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO leetcloud;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16867)
-- Name: appointments; Type: TABLE; Schema: public; Owner: leetcloud
--

CREATE TABLE public.appointments (
    appointmentid integer NOT NULL,
    patientid integer NOT NULL,
    doctorid integer NOT NULL,
    appointmentdate timestamp without time zone,
    status character varying(20) DEFAULT 'Scheduled'::character varying
);


ALTER TABLE public.appointments OWNER TO leetcloud;

--
-- TOC entry 217 (class 1259 OID 16866)
-- Name: appointments_appointmentid_seq; Type: SEQUENCE; Schema: public; Owner: leetcloud
--

CREATE SEQUENCE public.appointments_appointmentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointments_appointmentid_seq OWNER TO leetcloud;

--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 217
-- Name: appointments_appointmentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: leetcloud
--

ALTER SEQUENCE public.appointments_appointmentid_seq OWNED BY public.appointments.appointmentid;


--
-- TOC entry 214 (class 1259 OID 16843)
-- Name: doctors; Type: TABLE; Schema: public; Owner: leetcloud
--

CREATE TABLE public.doctors (
    doctorid integer NOT NULL,
    personid integer NOT NULL,
    specialization character varying(100),
    licensenumber character varying(50)
);


ALTER TABLE public.doctors OWNER TO leetcloud;

--
-- TOC entry 213 (class 1259 OID 16842)
-- Name: doctors_doctorid_seq; Type: SEQUENCE; Schema: public; Owner: leetcloud
--

CREATE SEQUENCE public.doctors_doctorid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.doctors_doctorid_seq OWNER TO leetcloud;

--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 213
-- Name: doctors_doctorid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: leetcloud
--

ALTER SEQUENCE public.doctors_doctorid_seq OWNED BY public.doctors.doctorid;


--
-- TOC entry 220 (class 1259 OID 16875)
-- Name: doctorschedule; Type: TABLE; Schema: public; Owner: leetcloud
--

CREATE TABLE public.doctorschedule (
    scheduleid integer NOT NULL,
    doctorid integer NOT NULL,
    recordtime timestamp without time zone,
    taskstatus character varying(20)
);


ALTER TABLE public.doctorschedule OWNER TO leetcloud;

--
-- TOC entry 219 (class 1259 OID 16874)
-- Name: doctorschedule_scheduleid_seq; Type: SEQUENCE; Schema: public; Owner: leetcloud
--

CREATE SEQUENCE public.doctorschedule_scheduleid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.doctorschedule_scheduleid_seq OWNER TO leetcloud;

--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 219
-- Name: doctorschedule_scheduleid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: leetcloud
--

ALTER SEQUENCE public.doctorschedule_scheduleid_seq OWNED BY public.doctorschedule.scheduleid;


--
-- TOC entry 216 (class 1259 OID 16857)
-- Name: medicalrecords; Type: TABLE; Schema: public; Owner: leetcloud
--

CREATE TABLE public.medicalrecords (
    medicalrecordid integer NOT NULL,
    patientid integer NOT NULL,
    doctorid integer NOT NULL,
    diagnosis text,
    comments text,
    recorddate timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.medicalrecords OWNER TO leetcloud;

--
-- TOC entry 215 (class 1259 OID 16856)
-- Name: medicalrecords_medicalrecordid_seq; Type: SEQUENCE; Schema: public; Owner: leetcloud
--

CREATE SEQUENCE public.medicalrecords_medicalrecordid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.medicalrecords_medicalrecordid_seq OWNER TO leetcloud;

--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 215
-- Name: medicalrecords_medicalrecordid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: leetcloud
--

ALTER SEQUENCE public.medicalrecords_medicalrecordid_seq OWNED BY public.medicalrecords.medicalrecordid;


--
-- TOC entry 212 (class 1259 OID 16831)
-- Name: patients; Type: TABLE; Schema: public; Owner: leetcloud
--

CREATE TABLE public.patients (
    patientid integer NOT NULL,
    personid integer NOT NULL,
    insurancenumber character varying(50)
);


ALTER TABLE public.patients OWNER TO leetcloud;

--
-- TOC entry 211 (class 1259 OID 16830)
-- Name: patients_patientid_seq; Type: SEQUENCE; Schema: public; Owner: leetcloud
--

CREATE SEQUENCE public.patients_patientid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patients_patientid_seq OWNER TO leetcloud;

--
-- TOC entry 3754 (class 0 OID 0)
-- Dependencies: 211
-- Name: patients_patientid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: leetcloud
--

ALTER SEQUENCE public.patients_patientid_seq OWNED BY public.patients.patientid;


--
-- TOC entry 210 (class 1259 OID 16822)
-- Name: persons; Type: TABLE; Schema: public; Owner: leetcloud
--

CREATE TABLE public.persons (
    personid integer NOT NULL,
    firstname character varying(100) NOT NULL,
    lastname character varying(100) NOT NULL,
    middlename character varying(100),
    dateofbirth date,
    gender character varying(10),
    contactinfo character varying(200),
    address text
);


ALTER TABLE public.persons OWNER TO leetcloud;

--
-- TOC entry 209 (class 1259 OID 16821)
-- Name: persons_personid_seq; Type: SEQUENCE; Schema: public; Owner: leetcloud
--

CREATE SEQUENCE public.persons_personid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.persons_personid_seq OWNER TO leetcloud;

--
-- TOC entry 3755 (class 0 OID 0)
-- Dependencies: 209
-- Name: persons_personid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: leetcloud
--

ALTER SEQUENCE public.persons_personid_seq OWNED BY public.persons.personid;


--
-- TOC entry 222 (class 1259 OID 17263)
-- Name: users; Type: TABLE; Schema: public; Owner: leetcloud
--

CREATE TABLE public.users (
    id integer NOT NULL,
    fio text NOT NULL,
    license_number text NOT NULL
);


ALTER TABLE public.users OWNER TO leetcloud;

--
-- TOC entry 221 (class 1259 OID 17262)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: leetcloud
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO leetcloud;

--
-- TOC entry 3756 (class 0 OID 0)
-- Dependencies: 221
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: leetcloud
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3563 (class 2604 OID 16870)
-- Name: appointments appointmentid; Type: DEFAULT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.appointments ALTER COLUMN appointmentid SET DEFAULT nextval('public.appointments_appointmentid_seq'::regclass);


--
-- TOC entry 3560 (class 2604 OID 16846)
-- Name: doctors doctorid; Type: DEFAULT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.doctors ALTER COLUMN doctorid SET DEFAULT nextval('public.doctors_doctorid_seq'::regclass);


--
-- TOC entry 3565 (class 2604 OID 16878)
-- Name: doctorschedule scheduleid; Type: DEFAULT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.doctorschedule ALTER COLUMN scheduleid SET DEFAULT nextval('public.doctorschedule_scheduleid_seq'::regclass);


--
-- TOC entry 3561 (class 2604 OID 16860)
-- Name: medicalrecords medicalrecordid; Type: DEFAULT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.medicalrecords ALTER COLUMN medicalrecordid SET DEFAULT nextval('public.medicalrecords_medicalrecordid_seq'::regclass);


--
-- TOC entry 3559 (class 2604 OID 16834)
-- Name: patients patientid; Type: DEFAULT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.patients ALTER COLUMN patientid SET DEFAULT nextval('public.patients_patientid_seq'::regclass);


--
-- TOC entry 3558 (class 2604 OID 16825)
-- Name: persons personid; Type: DEFAULT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.persons ALTER COLUMN personid SET DEFAULT nextval('public.persons_personid_seq'::regclass);


--
-- TOC entry 3566 (class 2604 OID 17266)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3739 (class 0 OID 16867)
-- Dependencies: 218
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: leetcloud
--

COPY public.appointments (appointmentid, patientid, doctorid, appointmentdate, status) FROM stdin;
1	1	1	2025-10-28 10:00:00	Запланирован
2	2	2	2025-10-28 11:30:00	Запланирован
3	3	3	2025-10-29 09:15:00	Запланирован
4	4	1	2025-10-29 14:00:00	Отменен
5	1	3	2025-10-30 16:30:00	Запланирован
\.


--
-- TOC entry 3735 (class 0 OID 16843)
-- Dependencies: 214
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: leetcloud
--

COPY public.doctors (doctorid, personid, specialization, licensenumber) FROM stdin;
1	5	Кардиолог	LIC001234
2	6	Невролог	LIC002345
3	7	Терапевт	LIC003456
5	1	Терапевт	LIC12345
6	1	Кардиолог	LIC55555
7	35	Невролог	LIC84053
\.


--
-- TOC entry 3741 (class 0 OID 16875)
-- Dependencies: 220
-- Data for Name: doctorschedule; Type: TABLE DATA; Schema: public; Owner: leetcloud
--

COPY public.doctorschedule (scheduleid, doctorid, recordtime, taskstatus) FROM stdin;
1	1	2025-10-28 09:00:00	Прием пациентов
2	1	2025-10-28 10:00:00	Консультация
3	1	2025-10-28 11:00:00	Операция
4	2	2025-10-28 08:30:00	Обход палат
5	2	2025-10-28 10:00:00	Диагностика
6	3	2025-10-28 09:00:00	Прием пациентов
7	3	2025-10-28 14:00:00	Консультация
\.


--
-- TOC entry 3737 (class 0 OID 16857)
-- Dependencies: 216
-- Data for Name: medicalrecords; Type: TABLE DATA; Schema: public; Owner: leetcloud
--

COPY public.medicalrecords (medicalrecordid, patientid, doctorid, diagnosis, comments, recorddate) FROM stdin;
1	1	1	Артериальная гипертензия	Пациенту назначены регулярные обследования и медикаментозная терапия. Рекомендовано снижение потребления соли.	2025-10-20 09:30:00
2	2	2	Остеохондроз шейного отдела	Назначен курс физиотерапии и лечебной гимнастики. Рекомендовано избегать длительного сидения.	2025-10-21 11:15:00
3	3	3	Острый бронхит	Прописан курс антибиотиков и противовоспалительных препаратов. Рекомендован постельный режим.	2025-10-22 14:20:00
4	1	1	Контрольный осмотр	Состояние пациента стабильное. Артериальное давление в норме. Корректировка дозировки препаратов.	2025-10-24 10:00:00
5	4	3	Профилактический осмотр	Пациент здоров. Рекомендованы регулярные физические нагрузки и сбалансированное питание.	2025-10-23 16:45:00
\.


--
-- TOC entry 3733 (class 0 OID 16831)
-- Dependencies: 212
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: leetcloud
--

COPY public.patients (patientid, personid, insurancenumber) FROM stdin;
1	1	INS00123456
2	2	INS00234567
3	3	INS00345678
4	4	INS00456789
21	2	INS33333
\.


--
-- TOC entry 3731 (class 0 OID 16822)
-- Dependencies: 210
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: leetcloud
--

COPY public.persons (personid, firstname, lastname, middlename, dateofbirth, gender, contactinfo, address) FROM stdin;
1	Анна	Иванова	Петровна	1985-03-15	Женский	anna@mail.com	Москва, ул. Ленина, 25
2	Дмитрий	Смирнов	Александрович	1978-11-22	Мужской	dmitry@mail.com	Москва, пр. Мира, 10
3	Елена	Кузнецова	Сергеевна	1992-07-08	Женский	elena@mail.com	Москва, ул. Пушкина, 15
4	Михаил	Попов	Игоревич	1980-12-30	Мужской	mikhail@mail.com	Москва, ул. Гагарина, 8
5	Александр	Петров	Викторович	1975-05-10	Мужской	petrov@hospital.ru	Москва, ул. Садовая, 12
6	Ольга	Сидорова	Николаевна	1982-09-18	Женский	sidorova@hospital.ru	Москва, пр. Вернадского, 45
7	Сергей	Васильев	Дмитриевич	1968-02-28	Мужской	vasiliev@hospital.ru	Москва, ул. Тверская, 30
34	Иван	Иванов	Иванович	1980-01-01	Male	ivan@clinic.com	Москва
35	Анна	Фролова	Петровна	1985-03-15	Женский	+79991234567	Москва
\.


--
-- TOC entry 3743 (class 0 OID 17263)
-- Dependencies: 222
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: leetcloud
--

COPY public.users (id, fio, license_number) FROM stdin;
1	Сергей Петров	LIC99999
2	Тест Врач	AUTH123
\.


--
-- TOC entry 3757 (class 0 OID 0)
-- Dependencies: 217
-- Name: appointments_appointmentid_seq; Type: SEQUENCE SET; Schema: public; Owner: leetcloud
--

SELECT pg_catalog.setval('public.appointments_appointmentid_seq', 5, true);


--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 213
-- Name: doctors_doctorid_seq; Type: SEQUENCE SET; Schema: public; Owner: leetcloud
--

SELECT pg_catalog.setval('public.doctors_doctorid_seq', 7, true);


--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 219
-- Name: doctorschedule_scheduleid_seq; Type: SEQUENCE SET; Schema: public; Owner: leetcloud
--

SELECT pg_catalog.setval('public.doctorschedule_scheduleid_seq', 7, true);


--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 215
-- Name: medicalrecords_medicalrecordid_seq; Type: SEQUENCE SET; Schema: public; Owner: leetcloud
--

SELECT pg_catalog.setval('public.medicalrecords_medicalrecordid_seq', 5, true);


--
-- TOC entry 3761 (class 0 OID 0)
-- Dependencies: 211
-- Name: patients_patientid_seq; Type: SEQUENCE SET; Schema: public; Owner: leetcloud
--

SELECT pg_catalog.setval('public.patients_patientid_seq', 21, true);


--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 209
-- Name: persons_personid_seq; Type: SEQUENCE SET; Schema: public; Owner: leetcloud
--

SELECT pg_catalog.setval('public.persons_personid_seq', 35, true);


--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 221
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: leetcloud
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- TOC entry 3578 (class 2606 OID 16873)
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (appointmentid);


--
-- TOC entry 3572 (class 2606 OID 16850)
-- Name: doctors doctors_licensenumber_key; Type: CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_licensenumber_key UNIQUE (licensenumber);


--
-- TOC entry 3574 (class 2606 OID 16848)
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (doctorid);


--
-- TOC entry 3580 (class 2606 OID 16880)
-- Name: doctorschedule doctorschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.doctorschedule
    ADD CONSTRAINT doctorschedule_pkey PRIMARY KEY (scheduleid);


--
-- TOC entry 3576 (class 2606 OID 16865)
-- Name: medicalrecords medicalrecords_pkey; Type: CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.medicalrecords
    ADD CONSTRAINT medicalrecords_pkey PRIMARY KEY (medicalrecordid);


--
-- TOC entry 3570 (class 2606 OID 16836)
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (patientid);


--
-- TOC entry 3568 (class 2606 OID 16829)
-- Name: persons persons_pkey; Type: CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_pkey PRIMARY KEY (personid);


--
-- TOC entry 3583 (class 2606 OID 17270)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3581 (class 1259 OID 17271)
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: leetcloud
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- TOC entry 3585 (class 2606 OID 16851)
-- Name: doctors doctors_personid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_personid_fkey FOREIGN KEY (personid) REFERENCES public.persons(personid);


--
-- TOC entry 3588 (class 2606 OID 16896)
-- Name: appointments fk_appointments_doctor; Type: FK CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointments_doctor FOREIGN KEY (doctorid) REFERENCES public.doctors(doctorid);


--
-- TOC entry 3589 (class 2606 OID 16891)
-- Name: appointments fk_appointments_patient; Type: FK CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointments_patient FOREIGN KEY (patientid) REFERENCES public.patients(patientid);


--
-- TOC entry 3590 (class 2606 OID 16901)
-- Name: doctorschedule fk_doctorschedule_doctor; Type: FK CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.doctorschedule
    ADD CONSTRAINT fk_doctorschedule_doctor FOREIGN KEY (doctorid) REFERENCES public.doctors(doctorid);


--
-- TOC entry 3586 (class 2606 OID 16886)
-- Name: medicalrecords fk_medicalrecords_doctor; Type: FK CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.medicalrecords
    ADD CONSTRAINT fk_medicalrecords_doctor FOREIGN KEY (doctorid) REFERENCES public.doctors(doctorid);


--
-- TOC entry 3587 (class 2606 OID 16881)
-- Name: medicalrecords fk_medicalrecords_patient; Type: FK CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.medicalrecords
    ADD CONSTRAINT fk_medicalrecords_patient FOREIGN KEY (patientid) REFERENCES public.patients(patientid);


--
-- TOC entry 3584 (class 2606 OID 16837)
-- Name: patients patients_personid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: leetcloud
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_personid_fkey FOREIGN KEY (personid) REFERENCES public.persons(personid);


--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: leetcloud
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2025-12-02 14:52:04 MSK

--
-- PostgreSQL database dump complete
--

