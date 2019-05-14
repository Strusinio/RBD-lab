-- Zapytanie wybierające wyniki meczow (data, numer koljeki, nazwa gospodarzy, gole gosopdarzy, nazwa gosci, gole gosci)
SELECT
	mecze.data,
	mecze.numer_kolejki,
	sedziowie.imie||' '||sedziowie.nazwisko AS sedzia,
	kluby_gospodarze.nazwa AS gospodarze,
	SUM(
		CASE 
			WHEN pilkarze.id_klubu = kluby_gospodarze.id THEN 1 
			ELSE 0 
		END
	) AS gole_gospodarzy,
	kluby_gosci.nazwa AS goscie,
	SUM(
		CASE 
			WHEN pilkarze.id_klubu = kluby_gosci.id THEN 1 
			ELSE 0 
		END
	) AS gole_gospodarzy
FROM
	mecze
	INNER JOIN
	osoby AS sedziowie ON sedziowie.id = mecze.id_sedziego
	INNER JOIN
	kluby AS kluby_gospodarze ON mecze.id_klubu_gospodarzy = kluby_gospodarze.id
	INNER JOIN
	kluby AS kluby_gosci ON mecze.id_klubu_gosci = kluby_gosci.id
	INNER JOIN
	zdarzenia_w_meczu ON zdarzenia_w_meczu.id_meczu = mecze.id
	INNER JOIN
	pilkarze ON pilkarze.id = zdarzenia_w_meczu.id_pilkarza
WHERE
	zdarzenia_w_meczu.nazwa_zdarzenia = 'gol'
GROUP BY
	mecze.data,
	mecze.numer_kolejki,
	sedziowie.imie||' '||sedziowie.nazwisko,
	kluby_gospodarze.nazwa,
	kluby_gosci.nazwa;


-- Lista najlepszych strzelcow (imie i nazwisko, nazwa klubu, liczba strzelonych goli)
SELECT
	osoby_pilkarz.imie||' '||osoby_pilkarz.nazwisko AS pilkarz,
	kluby.nazwa AS nazwa_klubu,
	COUNT(*) AS liczba_goli
FROM
	pilkarze
	INNER JOIN
	osoby AS osoby_pilkarz ON osoby_pilkarz.id = pilkarze.id_osoby
	INNER JOIN
	kluby ON kluby.id = pilkarze.id_klubu
	INNER JOIN
	zdarzenia_w_meczu ON zdarzenia_w_meczu.id_pilkarza = pilkarze.id
WHERE
	zdarzenia_w_meczu.nazwa_zdarzenia = 'gol'
GROUP BY
	osoby_pilkarz.imie||' '||osoby_pilkarz.nazwisko,
	kluby.nazwa
ORDER BY
	liczba_goli DESC

-- Tworzymy widok z danymi meczow (id gospodarzy i gosci, numer kolejki, data, gole gospodarzy i gosci)
SELECT
	mecze.data,
	mecze.numer_kolejki,
	sedziowie.id AS id_sedzia,
	kluby_gospodarze.id AS id_gospodarze,
	kluby_gospodarze.nazwa AS nazwa_gospodarze,
	SUM(
		CASE 
			WHEN pilkarze.id_klubu = kluby_gospodarze.id THEN 1 
			ELSE 0 
		END
	) AS gole_gospodarzy,
	kluby_gosci.id AS id_goscie,
	kluby_gosci.nazwa AS nazwa_goscie,
	SUM(
		CASE 
			WHEN pilkarze.id_klubu = kluby_gosci.id THEN 1 
			ELSE 0 
		END
	) AS gole_gosci
FROM
	mecze
	INNER JOIN
	osoby AS sedziowie ON sedziowie.id = mecze.id_sedziego
	INNER JOIN
	kluby AS kluby_gospodarze ON mecze.id_klubu_gospodarzy = kluby_gospodarze.id
	INNER JOIN
	kluby AS kluby_gosci ON mecze.id_klubu_gosci = kluby_gosci.id
	INNER JOIN
	zdarzenia_w_meczu ON zdarzenia_w_meczu.id_meczu = mecze.id
	INNER JOIN
	pilkarze ON pilkarze.id = zdarzenia_w_meczu.id_pilkarza
WHERE
	zdarzenia_w_meczu.nazwa_zdarzenia = 'gol'
GROUP BY
	mecze.data,
	mecze.numer_kolejki,
	sedziowie.id,
	kluby_gospodarze.id,
	kluby_gosci.id,
	kluby_gospodarze.nazwa,
	kluby_gosci.nazwa;

-- tworzymy widok tabeli druzyn
SELECT
	kluby.nazwa,
	SUM(CASE 
		WHEN kluby.id = wyniki_meczow.id_gospodarze THEN wyniki_meczow.gole_gospodarzy
		ELSE wyniki_meczow.gole_gosci
	END) AS gole_strzelone,
	SUM(CASE 
		WHEN kluby.id = wyniki_meczow.id_gospodarze THEN wyniki_meczow.gole_gosci
		ELSE wyniki_meczow.gole_gospodarzy
	END) AS gole_stracone,
	SUM(
		CASE 
			WHEN kluby.id = wyniki_meczow.id_gospodarze AND wyniki_meczow.gole_gospodarzy > wyniki_meczow.gole_gosci
					OR kluby.id = wyniki_meczow.id_goscie AND wyniki_meczow.gole_gosci > wyniki_meczow.gole_gospodarzy THEN 3
			WHEN wyniki_meczow.gole_gospodarzy = wyniki_meczow.gole_gosci THEN 1
			ELSE 0
		END) AS punkty
FROM
	kluby
	INNER JOIN
	wyniki_meczow ON wyniki_meczow.id_gospodarze = kluby.id OR wyniki_meczow.id_goscie = kluby.id
GROUP BY
	kluby.nazwa
ORDER BY
	punkty DESC
	
-- tworzenie widoku trenerow (imie i nazwisko trenera, nazwa klubu)
SELECT
	trenerzy.imie||' '||trenerzy.nazwisko AS trener,
	kluby.nazwa AS nazwa_klubu
FROM
	kluby
	INNER JOIN
	osoby AS trenerzy ON trenerzy.id = kluby.id_trenera