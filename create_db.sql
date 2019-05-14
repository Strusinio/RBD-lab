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