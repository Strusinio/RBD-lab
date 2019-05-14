
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;



CREATE TABLE kluby (
    id integer NOT NULL,
    nazwa character varying(45) NOT NULL,
    miasto character varying(45) NOT NULL,
    adres character varying NOT NULL,
    data_zalozenia date,
    id_stadionu integer NOT NULL,
    id_trenera integer NOT NULL
);


ALTER TABLE kluby OWNER TO postgres;



CREATE TABLE mecze (
    id integer NOT NULL,
    id_klubu_gospodarzy integer NOT NULL,
    id_klubu_gosci integer NOT NULL,
    data date NOT NULL,
    id_sedziego integer NOT NULL,
    numer_kolejki integer NOT NULL
);


ALTER TABLE mecze OWNER TO postgres;



CREATE TABLE osoby (
    id integer NOT NULL,
    imie character varying(45) NOT NULL,
    nazwisko character varying(45) NOT NULL,
    data_urodzenia date
);


ALTER TABLE osoby OWNER TO postgres;



CREATE TABLE pilkarze (
    id integer NOT NULL,
    id_osoby integer NOT NULL,
    numer integer NOT NULL,
    id_klubu integer NOT NULL
);


ALTER TABLE pilkarze OWNER TO postgres;



CREATE TABLE stadiony (
    id integer NOT NULL,
    nazwa character varying(45) NOT NULL,
    miasto character varying(45) NOT NULL,
    pojemnosc integer
);


ALTER TABLE stadiony OWNER TO postgres;



CREATE TABLE zdarzenia_w_meczu (
    id integer NOT NULL,
    minuta integer NOT NULL,
    id_pilkarza integer NOT NULL,
    id_meczu integer NOT NULL,
    nazwa_zdarzenia character varying(45) NOT NULL
);


ALTER TABLE zdarzenia_w_meczu OWNER TO postgres;



CREATE VIEW wyniki_meczow AS
 SELECT mecze.data,
    mecze.numer_kolejki,
    sedziowie.id AS id_sedzia,
    kluby_gospodarze.id AS id_gospodarze,
    kluby_gospodarze.nazwa AS nazwa_gospodarze,
    sum(
        CASE
            WHEN (pilkarze.id_klubu = kluby_gospodarze.id) THEN 1
            ELSE 0
        END) AS gole_gospodarzy,
    kluby_gosci.id AS id_goscie,
    kluby_gosci.nazwa AS nazwa_goscie,
    sum(
        CASE
            WHEN (pilkarze.id_klubu = kluby_gosci.id) THEN 1
            ELSE 0
        END) AS gole_gosci
   FROM (((((mecze
     JOIN osoby sedziowie ON ((sedziowie.id = mecze.id_sedziego)))
     JOIN kluby kluby_gospodarze ON ((mecze.id_klubu_gospodarzy = kluby_gospodarze.id)))
     JOIN kluby kluby_gosci ON ((mecze.id_klubu_gosci = kluby_gosci.id)))
     JOIN zdarzenia_w_meczu ON ((zdarzenia_w_meczu.id_meczu = mecze.id)))
     JOIN pilkarze ON ((pilkarze.id = zdarzenia_w_meczu.id_pilkarza)))
  WHERE ((zdarzenia_w_meczu.nazwa_zdarzenia)::text = 'gol'::text)
  GROUP BY mecze.data, mecze.numer_kolejki, sedziowie.id, kluby_gospodarze.id, kluby_gosci.id, kluby_gospodarze.nazwa, kluby_gosci.nazwa;


ALTER TABLE wyniki_meczow OWNER TO postgres;



CREATE VIEW tabela AS
 SELECT kluby.nazwa,
    sum(
        CASE
            WHEN (kluby.id = wyniki_meczow.id_gospodarze) THEN wyniki_meczow.gole_gospodarzy
            ELSE wyniki_meczow.gole_gosci
        END) AS gole_strzelone,
    sum(
        CASE
            WHEN (kluby.id = wyniki_meczow.id_gospodarze) THEN wyniki_meczow.gole_gosci
            ELSE wyniki_meczow.gole_gospodarzy
        END) AS gole_stracone,
    sum(
        CASE
            WHEN (((kluby.id = wyniki_meczow.id_gospodarze) AND (wyniki_meczow.gole_gospodarzy > wyniki_meczow.gole_gosci)) OR ((kluby.id = wyniki_meczow.id_goscie) AND (wyniki_meczow.gole_gosci > wyniki_meczow.gole_gospodarzy))) THEN 3
            WHEN (wyniki_meczow.gole_gospodarzy = wyniki_meczow.gole_gosci) THEN 1
            ELSE 0
        END) AS punkty
   FROM (kluby
     JOIN wyniki_meczow ON (((wyniki_meczow.id_gospodarze = kluby.id) OR (wyniki_meczow.id_goscie = kluby.id))))
  GROUP BY kluby.nazwa
  ORDER BY (sum(
        CASE
            WHEN (((kluby.id = wyniki_meczow.id_gospodarze) AND (wyniki_meczow.gole_gospodarzy > wyniki_meczow.gole_gosci)) OR ((kluby.id = wyniki_meczow.id_goscie) AND (wyniki_meczow.gole_gosci > wyniki_meczow.gole_gospodarzy))) THEN 3
            WHEN (wyniki_meczow.gole_gospodarzy = wyniki_meczow.gole_gosci) THEN 1
            ELSE 0
        END)) DESC;


ALTER TABLE tabela OWNER TO postgres;



CREATE VIEW trenerzy AS
 SELECT (((trenerzy.imie)::text || ' '::text) || (trenerzy.nazwisko)::text) AS trener,
    kluby.nazwa AS nazwa_klubu
   FROM (kluby
     JOIN osoby trenerzy ON ((trenerzy.id = kluby.id_trenera)));


ALTER TABLE trenerzy OWNER TO postgres;



INSERT INTO kluby (id, nazwa, miasto, adres, data_zalozenia, id_stadionu, id_trenera) VALUES (1, 'Klub1', 'Miasto1', 'adres1', '1950-01-01', 1, 1);
INSERT INTO kluby (id, nazwa, miasto, adres, data_zalozenia, id_stadionu, id_trenera) VALUES (2, 'Klub2', 'Miasto2', 'adres2', '1960-02-02', 2, 2);




INSERT INTO mecze (id, id_klubu_gospodarzy, id_klubu_gosci, data, id_sedziego, numer_kolejki) VALUES (1, 1, 2, '2018-01-24', 1, 1);
INSERT INTO mecze (id, id_klubu_gospodarzy, id_klubu_gosci, data, id_sedziego, numer_kolejki) VALUES (2, 2, 1, '2018-01-15', 3, 2);




INSERT INTO osoby (id, imie, nazwisko, data_urodzenia) VALUES (1, 'Imie1', 'Nazwisko1', '1980-01-01');
INSERT INTO osoby (id, imie, nazwisko, data_urodzenia) VALUES (2, 'Imie2', 'Nazwisko2', '1981-02-02');
INSERT INTO osoby (id, imie, nazwisko, data_urodzenia) VALUES (3, 'Imie3', 'Nazwisko3', '1982-03-03');
INSERT INTO osoby (id, imie, nazwisko, data_urodzenia) VALUES (4, 'Imie4', 'Nazwisko4', '1983-04-04');




INSERT INTO pilkarze (id, id_osoby, numer, id_klubu) VALUES (1, 1, 7, 1);
INSERT INTO pilkarze (id, id_osoby, numer, id_klubu) VALUES (2, 2, 8, 1);
INSERT INTO pilkarze (id, id_osoby, numer, id_klubu) VALUES (3, 3, 7, 2);
INSERT INTO pilkarze (id, id_osoby, numer, id_klubu) VALUES (4, 4, 8, 2);




INSERT INTO stadiony (id, nazwa, miasto, pojemnosc) VALUES (1, 'Stadion1', 'Miasto1', 20000);
INSERT INTO stadiony (id, nazwa, miasto, pojemnosc) VALUES (2, 'Stadion2', 'Miasto2', 15000);
INSERT INTO stadiony (id, nazwa, miasto, pojemnosc) VALUES (3, 'Stadion3', 'Miasto3', 5000);
INSERT INTO stadiony (id, nazwa, miasto, pojemnosc) VALUES (4, 'Stadion4', 'Miasto4', 10000);



INSERT INTO zdarzenia_w_meczu (id, minuta, id_pilkarza, id_meczu, nazwa_zdarzenia) VALUES (1, 10, 1, 1, 'gol');
INSERT INTO zdarzenia_w_meczu (id, minuta, id_pilkarza, id_meczu, nazwa_zdarzenia) VALUES (2, 80, 3, 1, 'gol');
INSERT INTO zdarzenia_w_meczu (id, minuta, id_pilkarza, id_meczu, nazwa_zdarzenia) VALUES (3, 90, 2, 1, 'gol');
INSERT INTO zdarzenia_w_meczu (id, minuta, id_pilkarza, id_meczu, nazwa_zdarzenia) VALUES (4, 50, 1, 2, 'gol');
INSERT INTO zdarzenia_w_meczu (id, minuta, id_pilkarza, id_meczu, nazwa_zdarzenia) VALUES (5, 20, 4, 2, 'czerwona kartka');




ALTER TABLE ONLY kluby
    ADD CONSTRAINT kluby_pkey PRIMARY KEY (id);





ALTER TABLE ONLY mecze
    ADD CONSTRAINT "mecze_PK" PRIMARY KEY (id);




ALTER TABLE ONLY osoby
    ADD CONSTRAINT osoby_pkey PRIMARY KEY (id);




ALTER TABLE ONLY pilkarze
    ADD CONSTRAINT pilkarze_pkey PRIMARY KEY (id);



ALTER TABLE ONLY stadiony
    ADD CONSTRAINT stadiony_pkey PRIMARY KEY (id);




ALTER TABLE ONLY zdarzenia_w_meczu
    ADD CONSTRAINT zdarzenia_w_meczu_pkey PRIMARY KEY (id);




ALTER TABLE ONLY kluby
    ADD CONSTRAINT "kluby_FK_stadion" FOREIGN KEY (id_stadionu) REFERENCES stadiony(id);




ALTER TABLE ONLY kluby
    ADD CONSTRAINT "kluby_FK_trener" FOREIGN KEY (id_trenera) REFERENCES osoby(id);




ALTER TABLE ONLY mecze
    ADD CONSTRAINT "mecze_FK_goscie" FOREIGN KEY (id_klubu_gosci) REFERENCES kluby(id);




ALTER TABLE ONLY mecze
    ADD CONSTRAINT "mecze_FK_gospodarze" FOREIGN KEY (id_klubu_gospodarzy) REFERENCES kluby(id);




ALTER TABLE ONLY mecze
    ADD CONSTRAINT "mecze_FK_sedzia" FOREIGN KEY (id_sedziego) REFERENCES osoby(id);




ALTER TABLE ONLY pilkarze
    ADD CONSTRAINT "pilkarze_FK_klub" FOREIGN KEY (id_klubu) REFERENCES kluby(id);




ALTER TABLE ONLY pilkarze
    ADD CONSTRAINT "pilkarze_FK_osoba" FOREIGN KEY (id_osoby) REFERENCES osoby(id);


