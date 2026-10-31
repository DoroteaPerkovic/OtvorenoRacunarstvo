# Glazbeni albumi
Otvoreni skup podataka o glazbenim albumima, njihovim izvođačima, žanrovima i pjesmama. Obuhvaća albume na engleskom i hrvatskom jeziku uz pripadajuće pjesme s rednim brojem i trajanjem. Skup je nastao kao dio 1. laboratorijske vježbe iz predmeta Otvoreno računarstvo.

Podaci su pohranjeni u relacijskoj bazi PostgreSQL, a iz nje se automatski izvode u formate CSV i JSON.

| Metapodaci|     |
|-|-|
| Naziv skupa | Glazbeni albumi |
| Autor | Dorotea Perković |
| Verzija| 1.0 |
| Licencija | CC BY-SA 4.0|
| Jezik podataka | Hrvatski nazivi atributa te engleski i hrvatski nazivi albuma i pjesama|
| Izvor podataka | Popis pjesama, trajanja i godine izdanja djelomično su preuzeti s Wikipedije (hr.wikipedia.org, en.wikipedia.org), ocjene su subjektivna procjena autora|
| Vrsta skupa | Kataloški skup podataka |
| Datum izrade | 31. 10. 2026. |
| Baza podataka | PostgreSQL |
| Ključne riječi | glazba, albumi, pjesme, izvođači, otvoreni podaci |

## Model podataka
Baza je normalizirana i sastoji se od sljedećih tablica: izvodac, album, pjesma, zanr i album_zanr. Veza između tablica album i pjesme je roditelj-dijete (jedan album ima više pjesama), a veza između albuma i žanrova je N:M (jedan album može imati više žanrova te jedan žanr obuhvaća više albuma).

### Opis atributa
Nazivi atributa su isti u CSV i JSON datoteci. U CSV-u su svi atributi stupci, a u JSON-u su izvođač, žanrovi i pjesme ugniježđeni.

| Atribut | Tip | Opis|
|-|-|-|
| album_id | cijeli broj | Identifikator albuma |
| naziv_albuma | tekst | Naslov albuma |
| godina | cijeli broj | Godina izdanja albuma |
| jezik | tekst | Jezik na kojem su pjesme napisane (hrvatski ili engleski) |
| ocjena | decimalni broj | Subjektivna ocjena autora, između 0 i 10 |
| izvodac | tekst | Ime izvođača |
| drzava_izvodaca | tekst | Država izvođača |
| godina_osnutka_izvodaca | cijeli broj | Godina osnutka sastava; za solo izvođače godina početka karijere |
| zanrovi | tekst | Žanrovi albuma |
| redni_broj_pjesme | cijeli broj | Redni broj pjesme na albumu |
| naslov_pjesme | tekst | Naslov pjesme |
| trajanje_pjesme_s | cijeli broj | Trajanje pjesme u sekundama |

## Licencija
Ovaj skup podataka dostupan je pod licencijom [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/legalcode.en). Cijeli tekst licencije nalazi se u datoteci LICENSE.

## Izvor
Dio podataka (popis pjesama, trajanje pjesama i godine izdanja) preuzet je iz članaka na Wikipediji, koja je dostupna pod licencijom [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/legalcode.en). Podaci su izdvojeni iz članaka, prilagođeni (trajanje pjesama je pretvoreno u sekunde) i strukturirani u relacijsku bazu. Wikipedija i njezini autori ne podupiru ovaj skup podataka.

| Podatak | Izvor|
|-|-|
| ABBA |[Wikipedija](https://hr.wikipedia.org/wiki/ABBA#Studijski_albumi)|
|Alphaville|[Wikipedija](https://hr.wikipedia.org/wiki/Alphaville_(sastav))|
|Roxette|[Wikipedija](https://en.wikipedia.org/wiki/Roxette)|
|Oliver Dragojević|[Wikipedija](https://hr.wikipedia.org/wiki/Oliver_Dragojevi%C4%87#Studijski_albumi)|
|Parni valjak|[Wikipedija](https://hr.wikipedia.org/wiki/Parni_valjak#Studijski_albumi)|
|George Michael|[Wikipedija](https://hr.wikipedia.org/wiki/George_Michael)|
|Waterloo|[Wikipedija](https://hr.wikipedia.org/wiki/Waterloo_(album))|
|Voulez-Vous|[Wikipedija](https://hr.wikipedia.org/wiki/Voulez-Vous_(album))|
|Catching Rays on Giant|[Wikipedija](https://en.wikipedia.org/wiki/Catching_Rays_on_Giant)|
|Look Sharp|[Wikipedija](https://en.wikipedia.org/wiki/Look_Sharp!_(Roxette_album))|
|Joyride|[Wikipedija](https://en.wikipedia.org/wiki/Joyride_(Roxette_album))|
|Ljubavna pjesma|[Wikipedija](https://hr.wikipedia.org/wiki/Ljubavna_pjesma)|
|Anđeli se dosađuju?|[Wikipedija](https://hr.wikipedia.org/wiki/An%C4%91eli_se_dosa%C4%91uju%3F)|
|Faith|[Wikipedija](https://en.wikipedia.org/wiki/Faith_(George_Michael_album))|
|Voyage|[Wikipedija](https://en.wikipedia.org/wiki/Voyage_(ABBA_album))|
|Forever Young|[Wikipedija](https://en.wikipedia.org/wiki/Forever_Young_(Alphaville_album))|











