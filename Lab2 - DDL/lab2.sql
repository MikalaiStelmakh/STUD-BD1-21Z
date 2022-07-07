CREATE TABLE pracownicy
    (
        id_pracownika       NUMBER (4) CONSTRAINT pracownicy_pk PRIMARY KEY
        ,imie               VARCHAR2 (40 CHAR) NOT NULL
        ,nazwisko           VARCHAR2 (40 CHAR) NOT NULL
        ,zarobki            NUMBER (7, 2)
        ,data_zatrudnienia  DATE
        ,id_zakladu         NUMBER (4) NOT NULL
        ,id_kierownika      NUMBER (4)
        ,kod_stanowiska     NUMBER (4) NOT NULL
    );          
    

CREATE TABLE stanowiska
    (
        id_stanowiska       NUMBER (4) CONSTRAINT stanowiska_pk PRIMARY KEY
        ,nazwa              VARCHAR2 (40 CHAR) NOT NULL
        ,min_placa          NUMBER (6) NOT NULL
        ,max_placa          NUMBER (6) NOT NULL

    );

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

DROP TABLE zaklady;


CREATE TABLE zaklady
    (
        id_zakladu          NUMBER (4) CONSTRAINT zaklady_pk PRIMARY KEY
        ,nazwa              VARCHAR2 (40 CHAR) NOT NULL
        ,kod_managera       NUMBER (4) NOT NULL
    );

ALTER TABLE zaklady
    ADD CONSTRAINT zaklady_pracownicy_fk FOREIGN KEY ( kod_managera ) 
    REFERENCES pracownicy (id_pracownika);


ALTER TABLE stanowiska
    ADD CONSTRAINT min_placa_ograniczenie CHECK (min_placa > 1000);

    




