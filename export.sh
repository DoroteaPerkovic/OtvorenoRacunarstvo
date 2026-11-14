#!/usr/bin/env bash
set -euo pipefail

DB="${1:-GlazbeniAlbumi}"
NAZIV="glazbeni_albumi"

export PGCLIENTENCODING=UTF8
export PYTHONIOENCODING=utf-8

# CSV
psql -d "$DB" -c "\copy (SELECT * FROM v_albumi_csv) TO '${NAZIV}.csv' csv header"

# JSON
psql -d "$DB" -t -A -q -c "
SELECT json_agg(row_to_json(t) ORDER BY t.album_id) FROM (
  SELECT
    a.id      AS album_id,
    a.naziv   AS naziv_albuma,
    a.godina  AS godina,
    a.jezik   AS jezik,
    a.ocjena  AS ocjena,
    (SELECT row_to_json(x) FROM
       (SELECT i.ime AS ime, i.drzava AS drzava_izvodaca, i.godina_osnutka AS godina_osnutka_izvodaca) x
    ) AS izvodac,
    (SELECT json_agg(z.naziv ORDER BY z.naziv)
       FROM album_zanr az JOIN zanr z ON z.id = az.zanr_id
      WHERE az.album_id = a.id) AS zanrovi,
    (SELECT json_agg(row_to_json(p2) ORDER BY p2.redni_broj_pjesme) FROM
       (SELECT p.redni_broj AS redni_broj_pjesme, p.naslov AS naslov_pjesme, p.trajanje_s AS trajanje_pjesme_s
          FROM pjesma p WHERE p.album_id = a.id) p2
    ) AS pjesme
  FROM album a
  JOIN izvodac i ON i.id = a.izvodac_id
) t;

" | python -m json.tool --no-ensure-ascii --indent 2 > "${NAZIV}.json"

# Dump baze
pg_dump -d "$DB" > dump.sql

#export PGUSER=postgres
#./export.sh GlazbeniAlbumi