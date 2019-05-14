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