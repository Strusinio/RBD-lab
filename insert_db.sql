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