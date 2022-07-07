# Bazy Danych - Kolokwium 1

> 1. Obniż o 5% roczny budzet departamentom ktore nie posiadaja numeru kontaktowego. Zaokrąglij nowy budzet do 2 miejsc po przecinku.
```sql
UPDATE departments
SET year_budget = ROUND(year_budget*0.95, 2)
WHERE contact_number IS NULL;
```
> 2. Napisz polecenie, które doda do tabeli Positions doda ograniczenie, które zagwarantuje, że minimalne zarobki na każdym ze stanowisk będą większe od 200.
```sql
ALTER TABLE positions
    ADD CHECK (min_salary>200);
```
> 3. Napisz polecenie, które doda do tabeli departments kolumnę last_inspected. Kolumna może przyjmować wartość NULL, a wartość domyślna to data bieżąca (czas wydawania polecenia).
```sql
ALTER TABLE departments
    ADD last_inspected DATE DEFAULT SYSDATE;
```
> 4. W tabeli z projektami dodaj ograniczenie wymuszajace unikalnosc nazwy projektow.
```sql
ALTER TABLE projects
    ADD CONSTRAINT unique_name UNIQUE (name);
```
> 5. Napisz polecenie, które stworzy tabelę z grantami (projekty badawcze) pracowników. Uwzględnij klucz główny, nazwę grantu, jego nazwę skróconą (musi być unikalna), budżet (nie może być ujemny) oraz datę rozpoczęcia (wartość domyślna data bieżąca).
```sql
CREATE TABLE grants
(
    grant_id    NUMBER PRIMARY KEY,
    name        VARCHAR2(40 CHAR),
    short_name  VARCHAR(10 CHAR) UNIQUE,
    budget      NUMBER,
    date_of_start   DATE DEFAULT SYSDATE,
    CHECK(budget>=0)
);
```
> 6. Napisz zapytanie, które zwróci unikalne daty założenia departamentów.
```sql
SELECT DISTINCT(established) FROM departments;
```

> 7. Napisz zapytanie, które zwróci informacje dla stanowisk o rozpiętości widełek płacowych większej niż 3500. W wynikach zaprezentuj rozpietość tych widełek za pomocą aliasowanej kolumny.
```sql
SELECT max_salary-min_salary AS difference FROM positions
WHERE (max_salary - min_salary > 3500);
```

> 8. Napisz zapytanie które policzy średnią długość zatrudnienia pracowników mężczyzn (w latach). Do wyodrębnienia roku z daty można użyć funkcji EXTRACT.
```sql
SELECT AVG(MONTHS_BETWEEN(SYSDATE, date_employed)/12)
FROM employees WHERE gender = 'M';
```

> 9. Napisz zapytanie ktore zwroci informacje o projektach niezakonczonych (data konca jest pusta) wraz z informacja o pozostalym do wykorzystania budzecie.  Posortuj tę listę względem budzetu jaki pozostał do wykorzystania w projekcie malejąco.
```sql
SELECT p.*, p.estimated_budget-p.used_budget AS budget_left
FROM projects p
WHERE date_end IS NULL
ORDER BY estimated_budget-used_budget DESC NULLS LAST;
```

> 10. Napisz zapytanie, które zwróci liczbę znaków w najdłuższym nazwisku pracowników.
```sql
SELECT LENGTH(surname)
FROM employees
ORDER BY LENGTH(surname) DESC
FETCH FIRST 1 ROW ONLY;
```

> 11. Zaznacz prawidłowe odpowiedzi dotyczące polecenia RENAME

 - [X] a. Jest to polecenie z grupy DDL

 - [X] b. Nie można go cofnąć poleceniem ROLLBACK

 - [ ] c. Aby zatwierdzić wprowadzone przez niego zmiany należy wykonać COMMIT

 - [ ] d. Jest to polecenie z grupy DML

> 12. Polecenia modyfikujące dane w tabelach bazy danych to polecenia:

 - [X] a. DML

 - [ ] b. DQL

 - [ ] c. TCL

 - [ ] d. DDL

 - [ ] e. DCL

> 13. W bazie danych jest tabela animals. Chcąc zmienić nazwę tabeli na pets możesz użyć polecenia:
 - [ ] a. ALTER TABLE animals TO pets;

 - [X] b. RENAME animals TO pets;

 - [ ] c. RENAME animals pets;

 - [ ] d. ALTER animals TO pets;
