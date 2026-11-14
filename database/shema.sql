CREATE TABLE izvodac (
	id					SERIAL PRIMARY KEY,
	ime					TEXT NOT NULL UNIQUE,
	drzava				TEXT NOT NULL,
	godina_osnutka		INTEGER
);

CREATE TABLE zanr(
	id				SERIAL PRIMARY KEY,
	naziv			TEXT NOT NULL UNIQUE
);

CREATE TABLE album(
	id				SERIAL PRIMARY KEY,
	naziv			TEXT NOT NULL,
	godina			INTEGER,
	jezik			TEXT NOT NULL,
	ocjena			NUMERIC(3,1) CHECK (ocjena BETWEEN 0 AND 10),
	izvodac_id		INTEGER NOT NULL REFERENCES izvodac(id),
	UNIQUE (naziv, izvodac_id)
);

CREATE TABLE album_zanr (
    album_id INTEGER NOT NULL REFERENCES album(id) ON DELETE CASCADE,
    zanr_id  INTEGER NOT NULL REFERENCES zanr(id),
    PRIMARY KEY (album_id, zanr_id)
);

CREATE TABLE pjesma (
    id          SERIAL PRIMARY KEY,
    album_id    INTEGER NOT NULL REFERENCES album(id) ON DELETE CASCADE,
    redni_broj  INTEGER NOT NULL,
    naslov      TEXT NOT NULL,
    trajanje_s  INTEGER NOT NULL CHECK (trajanje_s > 0),
    UNIQUE (album_id, redni_broj)
);

CREATE VIEW v_albumi_csv AS
SELECT
    a.id                      AS album_id,
    a.naziv                   AS naziv_albuma,
    a.godina,
    a.jezik,
    a.ocjena,
    i.ime                     AS izvodac,
    i.drzava                  AS drzava_izvodaca,
    i.godina_osnutka          AS godina_osnutka_izvodaca,
    (SELECT string_agg(z.naziv, '; ' ORDER BY z.naziv)
       FROM album_zanr az JOIN zanr z ON z.id = az.zanr_id
      WHERE az.album_id = a.id) AS zanrovi,
    p.redni_broj              AS redni_broj_pjesme,
    p.naslov                  AS naslov_pjesme,
    p.trajanje_s              AS trajanje_pjesme_s
FROM album a
JOIN izvodac i ON i.id = a.izvodac_id
JOIN pjesma  p ON p.album_id = a.id
ORDER BY a.id, p.redni_broj;