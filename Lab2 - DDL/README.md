# Bazy Danych - Laboratorium 2 (DDL)
## Pocelenie `CREATE`
> Z wykorzystaniem polecenia CREATE TABLE utwórz tabelę STANOWISKA, która będzie przechowywać podstawowe dane o stanowiskach np. identyfikator, minimalną i maksymalną płacę, nazwę stanowiska.
```sql
CREATE TABLE stanowiska
    (
        id_stanowiska       NUMBER (4) CONSTRAINT stanowiska_pk PRIMARY KEY
        ,nazwa              VARCHAR2 (40 CHAR) NOT NULL
        ,min_placa          NUMBER (6) NOT NULL
        ,max_placa          NUMBER (6) NOT NULL

    );
```
> Z wykorzystaniem polecenia CREATE TABLE utwórz tabele REGIONY oraz KRAJE. Pamiętaj o umieszczeniu klucza obcego w ramach tabeli KRAJE do tabeli REGIONY.
```sql
CREATE TABLE kraje
    (
        id_kraju            NUMBER (4) CONSTRAINT kraje_pk PRIMARY KEY
        ,nazwa              VARCHAR2 (40 CHAR) NOT NULL
    );

CREATE TABLE regiony
    (
        id_regionu          NUMBER (4) CONSTRAINT regiony_pk PRIMARY KEY
        ,nazwa              VARCHAR2 (40 CHAR) NOT NULL
        ,id_kraju           NUMBER (4) NOT NULL REFERENCES kraje (id_kraju)
    );
```
## Polecenie `ALTER TABLE`
> Za pomocą polecenia CREATE TABLE utwórz tabelę ZAKŁADY, w której przechowywane są dane o zakładach pracy. Następnie poleceniem ALTER TABLE dodaj klucz obcy do tabeli ZAKŁADY, który wskaże managera danego zakładu.

```sql
CREATE TABLE zaklady
    (
        id_zakladu          NUMBER (4) CONSTRAINT zaklady_pk PRIMARY KEY
        ,nazwa              VARCHAR2 (40 CHAR) NOT NULL
        ,kod_managera       NUMBER (4) NOT NULL
    );

ALTER TABLE zaklady
    ADD CONSTRAINT zaklady_pracownicy_fk FOREIGN KEY ( kod_managera )
    REFERENCES pracownicy (id_pracownika);
```

> Dla tabeli STANOWISKA z użyciem polecenia ALTER TABLE ogranicz płace na stanowiskach do min. 1000.

```sql
ALTER TABLE stanowiska
    ADD CONSTRAINT min_placa_ograniczenie CHECK (min_placa > 1000);
```
