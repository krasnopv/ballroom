--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;


---
--- Clear up tables
---
DROP TABLE IF EXISTS affiliation CASCADE;
DROP TABLE IF EXISTS competition CASCADE;
DROP TABLE IF EXISTS admin CASCADE;
DROP TABLE IF EXISTS callback CASCADE;
DROP TABLE IF EXISTS competitor CASCADE;
DROP TABLE IF EXISTS paymentrecord CASCADE;
DROP TABLE IF EXISTS judge CASCADE;
DROP TABLE IF EXISTS event CASCADE;
DROP TABLE IF EXISTS level CASCADE;
DROP TABLE IF EXISTS partnership CASCADE;
DROP TABLE IF EXISTS round CASCADE;
DROP TABLE IF EXISTS style CASCADE;


--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE admin (
    email character varying(100) NOT NULL UNIQUE
);


ALTER TABLE admin OWNER TO postgres;

--
-- Name: affiliation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE affiliation (
    id SERIAL,
    name character varying(100) UNIQUE
);


ALTER TABLE affiliation OWNER TO postgres;

--
-- Name: callback; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE callback (
    id SERIAL,
    "timestamp" timestamp with time zone,
    judgeid integer,
    leadcompetitornumber integer,
    roundid integer,
    competitionid integer
);


ALTER TABLE callback OWNER TO postgres;

--
-- Name: competition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE competition (
    id SERIAL,
    name character varying(100),
    leadidstartnum integer,
    locationname character varying(100),
    earlyprice numeric(6,2),
    regularprice numeric(6,2),
    lateprice numeric(6,2),
    startdate timestamp with time zone,
    enddate timestamp with time zone,
    regstartdate timestamp with time zone,
    earlyregdeadline timestamp with time zone,
    regularregdeadline timestamp with time zone,
    lateregdeadline timestamp with time zone,
    compadmin character varying(100),
    currenteventid integer,
    description character varying(1000)
);


ALTER TABLE competition OWNER TO postgres;

--
-- Name: competitor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE competitor (
    id SERIAL,
    firstname character varying(30),
    lastname character varying(30),
    email character varying(100) NOT NULL UNIQUE,
    mailingaddress character varying(100),
    affiliationid integer,
    hasregistered boolean NOT NULL
);


ALTER TABLE competitor OWNER TO postgres;

--
-- Name: event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE event (
    id SERIAL,
    competitionid integer,
    styleid integer,
    levelid integer,
    dance character varying(30),
    ordernumber integer
);


ALTER TABLE event OWNER TO postgres;

--
-- Name: judge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE judge (
    id SERIAL,
    email character varying(100),
    token character varying(100),
    firstname character varying(30),
    lastname character varying(30),
    phonenumber character varying(30),
    competitionid integer
);


ALTER TABLE judge OWNER TO postgres;

--
-- Name: level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE level (
    id SERIAL,
    name character varying(30),
    ordernumber integer,
    competitionid integer
);


ALTER TABLE level OWNER TO postgres;

--
-- Name: partnership; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE partnership (
    leadcompetitorid integer NOT NULL,
    followcompetitorid integer NOT NULL,
    eventid integer NOT NULL,
    leadconfirmed boolean,
    followconfirmed boolean,
    competitionid integer,
    number integer,
    calledback boolean,
    "timestamp" timestamp with time zone
);


ALTER TABLE partnership OWNER TO postgres;

--
-- Name: paymentrecord; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE paymentrecord (
    id SERIAL,
    competitionid integer,
    "timestamp" timestamp with time zone,
    competitorid integer,
    amount numeric(6,2),
    online boolean,
    paidwithaffiliation boolean,
    UNIQUE (competitionid, competitorid)
);


ALTER TABLE paymentrecord OWNER TO postgres;

--
-- Name: round; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE round (
    id SERIAL,
    eventid integer,
    name character varying(100),
    ordernumber integer,
    size integer,
    nextround integer,
    judgeid1 integer,
    judgeid2 integer,
    judgeid3 integer,
    judgeid4 integer,
    judgeid5 integer,
    judgeid6 integer
);


ALTER TABLE round OWNER TO postgres;

--
-- Name: style; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE style (
    id SERIAL,
    name character varying(30),
    ordernumber integer,
    competitionid integer
);


ALTER TABLE style OWNER TO postgres;


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (email);


--
-- Name: affiliation affiliation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY affiliation
    ADD CONSTRAINT affiliation_pkey PRIMARY KEY (id);


--
-- Name: callback callback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY callback
    ADD CONSTRAINT callback_pkey PRIMARY KEY (id);


--
-- Name: competition competition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY competition
    ADD CONSTRAINT competition_pkey PRIMARY KEY (id);


--
-- Name: competitor competitor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY competitor
    ADD CONSTRAINT competitor_pkey PRIMARY KEY (id);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: judge judge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY judge
    ADD CONSTRAINT judge_pkey PRIMARY KEY (id);


--
-- Name: level level_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY level
    ADD CONSTRAINT level_pkey PRIMARY KEY (id);


--
-- Name: partnership partnership_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY partnership
    ADD CONSTRAINT partnership_pkey PRIMARY KEY (leadcompetitorid, followcompetitorid, eventid);


--
-- Name: paymentrecord paymentrecord_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY paymentrecord
    ADD CONSTRAINT paymentrecord_pkey PRIMARY KEY (id);


--
-- Name: round round_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY round
    ADD CONSTRAINT round_pkey PRIMARY KEY (id);


--
-- Name: style style_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY style
    ADD CONSTRAINT style_pkey PRIMARY KEY (id);


--
-- Name: callback callback_competitionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY callback
    ADD CONSTRAINT callback_competitionid_fkey FOREIGN KEY (competitionid) REFERENCES competition(id) ON DELETE CASCADE;


--
-- Name: callback callback_judgeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY callback
    ADD CONSTRAINT callback_judgeid_fkey FOREIGN KEY (judgeid) REFERENCES judge(id) ON DELETE CASCADE;


--
-- Name: callback callback_roundid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY callback
    ADD CONSTRAINT callback_roundid_fkey FOREIGN KEY (roundid) REFERENCES round(id) ON DELETE CASCADE;


--
-- Name: competition competition_compadmin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY competition
    ADD CONSTRAINT competition_compadmin_fkey FOREIGN KEY (compadmin) REFERENCES admin(email) ON DELETE CASCADE;


--
-- Name: competitor competitor_affiliationid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY competitor
    ADD CONSTRAINT competitor_affiliationid_fkey FOREIGN KEY (affiliationid) REFERENCES affiliation(id) ON DELETE CASCADE;


--
-- Name: event event_competitionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_competitionid_fkey FOREIGN KEY (competitionid) REFERENCES competition(id) ON DELETE CASCADE;


--
-- Name: event event_levelid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_levelid_fkey FOREIGN KEY (levelid) REFERENCES level(id) ON DELETE CASCADE;


--
-- Name: event event_styleid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_styleid_fkey FOREIGN KEY (styleid) REFERENCES style(id) ON DELETE CASCADE;


--
-- Name: judge judge_competitionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY judge
    ADD CONSTRAINT judge_competitionid_fkey FOREIGN KEY (competitionid) REFERENCES competition(id) ON DELETE CASCADE;


--
-- Name: level level_competitionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY level
    ADD CONSTRAINT level_competitionid_fkey FOREIGN KEY (competitionid) REFERENCES competition(id) ON DELETE CASCADE;


--
-- Name: partnership partnership_competitionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY partnership
    ADD CONSTRAINT partnership_competitionid_fkey FOREIGN KEY (competitionid) REFERENCES competition(id) ON DELETE CASCADE;


--
-- Name: partnership partnership_eventid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY partnership
    ADD CONSTRAINT partnership_eventid_fkey FOREIGN KEY (eventid) REFERENCES event(id) ON DELETE CASCADE;


--
-- Name: partnership partnership_followcompetitorid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY partnership
    ADD CONSTRAINT partnership_followcompetitorid_fkey FOREIGN KEY (followcompetitorid) REFERENCES competitor(id) ON DELETE CASCADE;


--
-- Name: partnership partnership_leadcompetitorid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY partnership
    ADD CONSTRAINT partnership_leadcompetitorid_fkey FOREIGN KEY (leadcompetitorid) REFERENCES competitor(id) ON DELETE CASCADE;


--
-- Name: paymentrecord paymentrecord_competitionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY paymentrecord
    ADD CONSTRAINT paymentrecord_competitionid_fkey FOREIGN KEY (competitionid) REFERENCES competition(id) ON DELETE CASCADE;


--
-- Name: paymentrecord paymentrecord_competitorid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY paymentrecord
    ADD CONSTRAINT paymentrecord_competitorid_fkey FOREIGN KEY (competitorid) REFERENCES competitor(id) ON DELETE CASCADE;


--
-- Name: round round_eventid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY round
    ADD CONSTRAINT round_eventid_fkey FOREIGN KEY (eventid) REFERENCES event(id) ON DELETE CASCADE;


--
-- Name: round round_judgeid1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY round
    ADD CONSTRAINT round_judgeid1_fkey FOREIGN KEY (judgeid1) REFERENCES judge(id) ON DELETE SET NULL;


--
-- Name: round round_judgeid2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY round
    ADD CONSTRAINT round_judgeid2_fkey FOREIGN KEY (judgeid2) REFERENCES judge(id) ON DELETE SET NULL;


--
-- Name: round round_judgeid3_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY round
    ADD CONSTRAINT round_judgeid3_fkey FOREIGN KEY (judgeid3) REFERENCES judge(id) ON DELETE SET NULL;


--
-- Name: round round_judgeid4_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY round
    ADD CONSTRAINT round_judgeid4_fkey FOREIGN KEY (judgeid4) REFERENCES judge(id) ON DELETE SET NULL;


--
-- Name: round round_judgeid5_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY round
    ADD CONSTRAINT round_judgeid5_fkey FOREIGN KEY (judgeid5) REFERENCES judge(id) ON DELETE SET NULL;


--
-- Name: round round_judgeid6_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY round
    ADD CONSTRAINT round_judgeid6_fkey FOREIGN KEY (judgeid6) REFERENCES judge(id) ON DELETE SET NULL;


--
-- Name: style style_competitionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY style
    ADD CONSTRAINT style_competitionid_fkey FOREIGN KEY (competitionid) REFERENCES competition(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


SELECT pg_catalog.setval('callback_id_seq', 1, false);

SELECT pg_catalog.setval('round_id_seq', 1, false);

INSERT INTO admin VALUES ('admin@email.edu');

INSERT INTO competition VALUES (1,'Name', 1, 'locationname', 10.00, 20.00, 30.00, '2017-05-10 00:00:00-04', '2017-05-10 00:00:00-04', '2017-05-05 00:00:00-04', '2017-05-07 00:00:00-04', '2017-05-08 00:00:00-04', '2017-05-09 00:00:00-04', 'admin@email.edu', 0, 'description');

SELECT pg_catalog.setval('competition_id_seq', 1, true);

INSERT INTO affiliation VALUES (1,'Cornell Dance Team');
INSERT INTO affiliation VALUES (2,'Harvard Dance Team');
INSERT INTO affiliation VALUES (3,'MIT Dance Team');
INSERT INTO affiliation VALUES (4,'Princeton Dance Team');

SELECT pg_catalog.setval('affiliation_id_seq', 4, true);

INSERT INTO level VALUES (1,'Bronze', 1, 1);
INSERT INTO level VALUES (2,'Silver', 2, 1);
INSERT INTO level VALUES (3,'Gold', 3, 1);

SELECT pg_catalog.setval('level_id_seq', 3, true);

INSERT INTO competitor VALUES (1,'Luke', 'Skywalker', 'luke@skywalker.com', 'Tatooine', 1, true);
INSERT INTO competitor VALUES (2,'Leia', 'Organa', 'leia@organa.com', 'Alderaan', 1, true);
INSERT INTO competitor VALUES (3,'Rey', 'who knows', 'rey@rey.com', 'Jakku', 1, false);
INSERT INTO competitor VALUES (4,'fname1', 'lname1', 'email1@email.com', 'mailingaddress1', 2, false);
INSERT INTO competitor VALUES (5,'fname2', 'lname2', 'email2@email.com', 'mailingaddress2', 2, false);
INSERT INTO competitor VALUES (6,'fname3', 'lname3', 'email3@email.com', 'mailingaddress3', 3, false);
INSERT INTO competitor VALUES (7,'fname7', 'lname7', 'email7@email.com', 'mailingaddress7', 4, false);
INSERT INTO competitor VALUES (8,'fname8', 'lname8', 'email8@email.com', 'mailingaddress8', 4, false);
INSERT INTO competitor VALUES (9,'fname9', 'lname9', 'email9@email.com', 'mailingaddress9', 4, false);
INSERT INTO competitor VALUES (10,'fname10', 'lname10', 'email10@email.com', 'mailingaddress10', 4, false);
INSERT INTO competitor VALUES (11,'fname11', 'lname11', 'email11@email.com', 'mailingaddress11', 4, false);
INSERT INTO competitor VALUES (12,'fname12', 'lname12', 'email12@email.com', 'mailingaddress12', 4, false);
INSERT INTO competitor VALUES (13,'fname13', 'lname13', 'email13@email.com', 'mailingaddress13', 4, false);
INSERT INTO competitor VALUES (14,'fname14', 'lname14', 'email14@email.com', 'mailingaddress14', 4, false);
INSERT INTO competitor VALUES (15,'fname15', 'lname15', 'email15@email.com', 'mailingaddress15', 4, false);
INSERT INTO competitor VALUES (16,'fname10', 'lname16', 'email16@email.com', 'mailingaddress16', 4, false);
INSERT INTO competitor VALUES (17,'fname17', 'lname17', 'email17@email.com', 'mailingaddress17', 4, false);
INSERT INTO competitor VALUES (18,'fname18', 'lname18', 'email18@email.com', 'mailingaddress18', 4, false);
INSERT INTO competitor VALUES (19,'fname19', 'lname19', 'email19@email.com', 'mailingaddress19', 4, false);
INSERT INTO competitor VALUES (20,'fname20', 'lname20', 'email20@email.com', 'mailingaddress20', 4, false);
INSERT INTO competitor VALUES (21,'fname21', 'lname21', 'email21@email.com', 'mailingaddress21', 4, false);
INSERT INTO competitor VALUES (22,'fname22', 'lname22', 'email22@email.com', 'mailingaddress22', 4, false);
INSERT INTO competitor VALUES (23,'fname23', 'lname23', 'email23@email.com', 'mailingaddress23', 4, false);
INSERT INTO competitor VALUES (24,'fname24', 'lname24', 'email24@email.com', 'mailingaddress24', 4, false);
INSERT INTO competitor VALUES (25,'fname25', 'lname25', 'email25@email.com', 'mailingaddress25', 4, false);
INSERT INTO competitor VALUES (26,'fname20', 'lname26', 'email26@email.com', 'mailingaddress26', 4, false);
INSERT INTO competitor VALUES (27,'fname27', 'lname27', 'email27@email.com', 'mailingaddress27', 4, false);
INSERT INTO competitor VALUES (28,'fname28', 'lname28', 'email28@email.com', 'mailingaddress28', 4, false);
INSERT INTO competitor VALUES (29,'fname29', 'lname29', 'email29@email.com', 'mailingaddress29', 4, false);
INSERT INTO competitor VALUES (30,'fname30', 'lname30', 'email30@email.com', 'mailingaddress30', 4, false);
INSERT INTO competitor VALUES (31,'fname31', 'lname31', 'email31@email.com', 'mailingaddress31', 4, false);
INSERT INTO competitor VALUES (32,'fname32', 'lname32', 'email32@email.com', 'mailingaddress32', 4, false);
INSERT INTO competitor VALUES (33,'fname33', 'lname33', 'email33@email.com', 'mailingaddress33', 4, false);
INSERT INTO competitor VALUES (34,'fname34', 'lname34', 'email34@email.com', 'mailingaddress34', 4, false);
INSERT INTO competitor VALUES (35,'fname35', 'lname35', 'email35@email.com', 'mailingaddress35', 4, false);
INSERT INTO competitor VALUES (36,'fname30', 'lname36', 'email36@email.com', 'mailingaddress36', 4, false);
INSERT INTO competitor VALUES (37,'fname37', 'lname37', 'email37@email.com', 'mailingaddress37', 4, false);
INSERT INTO competitor VALUES (38,'fname38', 'lname38', 'email38@email.com', 'mailingaddress38', 4, false);
INSERT INTO competitor VALUES (39,'fname39', 'lname39', 'email39@email.com', 'mailingaddress39', 4, false);
INSERT INTO competitor VALUES (40,'fname40', 'lname40', 'email40@email.com', 'mailingaddress40', 4, false);
INSERT INTO competitor VALUES (41,'fname41', 'lname41', 'email41@email.com', 'mailingaddress41', 4, false);
INSERT INTO competitor VALUES (42,'fname42', 'lname42', 'email42@email.com', 'mailingaddress42', 4, false);
INSERT INTO competitor VALUES (43,'fname43', 'lname43', 'email43@email.com', 'mailingaddress43', 4, false);
INSERT INTO competitor VALUES (44,'fname44', 'lname44', 'email44@email.com', 'mailingaddress44', 4, false);
INSERT INTO competitor VALUES (45,'fname45', 'lname45', 'email45@email.com', 'mailingaddress45', 4, false);
INSERT INTO competitor VALUES (46,'fname40', 'lname46', 'email46@email.com', 'mailingaddress46', 4, false);
INSERT INTO competitor VALUES (47,'fname47', 'lname47', 'email47@email.com', 'mailingaddress47', 4, false);
INSERT INTO competitor VALUES (48,'fname48', 'lname48', 'email48@email.com', 'mailingaddress48', 4, false);
INSERT INTO competitor VALUES (49,'fname49', 'lname49', 'email49@email.com', 'mailingaddress49', 4, false);
INSERT INTO competitor VALUES (50,'fname50', 'lname50', 'email50@email.com', 'mailingaddress50', 4, false);

SELECT pg_catalog.setval('competitor_id_seq', 50, true);


INSERT INTO judge VALUES (1,'len@goodman.com', 'judgetoken', 'Len', 'Goodman', '626-555-5555', 1);
INSERT INTO judge VALUES (2,'bruno@tonioli.com', 'judgetoken', 'Bruno', 'Tonioli', '626-655-5555', 1);
INSERT INTO judge VALUES (3,'carrieann@inaba.com', 'judgetoken', 'Carrie Ann', 'Inaba', '626-565-5555', 1);
INSERT INTO judge VALUES (4,'julianne@hough.com', 'judgetoken', 'Julianne', 'Hough', '626-556-5555', 1);
INSERT INTO judge VALUES (5,'tom@bergeron.com', 'judgetoken', 'Tom', 'Bergeron', '626-555-6555', 1);
INSERT INTO judge VALUES (6,'erin@andrews.com', 'judgetoken', 'Erin', 'Andrews', '626-555-5655', 1);

SELECT pg_catalog.setval('judge_id_seq', 6, true);

INSERT INTO style VALUES (1, 'Latin', 1, 1);
INSERT INTO style VALUES (2, 'Smooth', 2, 1);
INSERT INTO style VALUES (3, 'Rough', 3, 1);

SELECT pg_catalog.setval('style_id_seq', 3, true);

INSERT INTO event VALUES (1, 1, 1, 1, 'Waltz', 1);
INSERT INTO event VALUES (2, 1, 2, 1, 'Waltz', 2);
INSERT INTO event VALUES (3, 1, 1, 2, 'Tango', 3);
INSERT INTO event VALUES (4, 1, 2, 2, 'Tango', 4);
INSERT INTO event VALUES (5, 1, 1, 3, 'Cha Cha', 5);
INSERT INTO event VALUES (6, 1, 2, 3, 'Cha Cha', 6);

SELECT pg_catalog.setval('event_id_seq', 6, true);

INSERT INTO partnership VALUES (1, 2, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (1, 2, 6, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (1, 3, 2, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (1, 3, 5, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (1, 4, 3, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (1, 4, 4, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (1, 5, 3, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (1, 5, 4, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (1, 6, 2, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (1, 6, 5, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (2, 3, 6, true, true, 1, 2, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (2, 5, 2, true, true, 1, 2, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (2, 5, 5, true, true, 1, 2, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (2, 6, 3, true, true, 1, 2, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (2, 6, 4, true, true, 1, 2, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (3, 4, 3, true, true, 1, 3, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (3, 4, 4, true, true, 1, 3, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (3, 5, 5, true, true, 1, 3, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (3, 6, 1, true, true, 1, 3, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (3, 6, 6, true, true, 1, 3, true, '2017-05-10 00:00:00-04');

INSERT INTO partnership VALUES (1, 3, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (1, 4, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (1, 5, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (1, 6, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');

INSERT INTO partnership VALUES (7, 8, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (9, 10, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (11, 12, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (13, 14, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (15, 16, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (17, 18, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (19, 20, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (21, 22, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (23, 24, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (25, 26, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (27, 28, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (29, 30, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (31, 32, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (33, 34, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (35, 36, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (37, 38, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (39, 40, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (41, 42, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (43, 44, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (45, 46, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (47, 48, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');
INSERT INTO partnership VALUES (49, 50, 1, true, true, 1, 1, true, '2017-05-10 00:00:00-04');

INSERT INTO paymentrecord VALUES (1, 1, '2017-05-10 00:00:00-04', 1, 21.87, true, true);

SELECT pg_catalog.setval('paymentrecord_id_seq', 1, true);