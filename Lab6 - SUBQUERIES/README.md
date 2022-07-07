# Bazy Danych - Laboratorium 6 (SUBQUERIES)
## Podzapytanie zwraca jeden wiersz danych
> Napisz zapytanie, które wyświetli imię, nazwisko oraz nazwy zakładów, w których pracownicy mają większe zarobki niż minimalne zarobki na stanowisku o nazwie ‘Konsultant’.
```sql
SELECT e.employee_id, e.name, e.surname, e.salary, d.name
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
WHERE salary > (
    SELECT MIN(salary)
    FROM employees e JOIN positions p USING (position_id)
    WHERE p.name = 'Konsultant'
    );
```
> Napisz zapytanie, które zwróci dane najmłodszego wśród dzieci pracowników. (Skorzystaj z podzapytań. Jaki jest inny sposób na osiągnięcie tego wyniku?)
```sql
SELECT * FROM dependents
WHERE birth_date = (
    SELECT MAX(birth_date)
    FROM dependents
);
```
> Napisz zapytanie, które zwróci dane dzieci najstarszego pracownika z zakładu 102.
```sql
SELECT *
FROM dependents
WHERE employee_id = (
    SELECT employee_id FROM employees
    WHERE position_id = 102
    ORDER BY birth_date FETCH FIRST ROW ONLY
    );
```
> Napisz zapytanie, które wyświetli wszystkich pracowników, którzy zostali zatrudnieni nie wcześniej niż najwcześniej zatrudniony pracownik w zakładzie o id 101 i nie później niż najpóźniej zatrudniony pracownik w zakładzie o id 107.
```sql
SELECT * FROM employees
WHERE date_employed BETWEEN
    (
        SELECT MIN(date_employed) FROM employees
        WHERE department_id = 101
    )
    AND
    (
        SELECT MAX(date_employed) FROM employees
        WHERE department_id = 107
    );
```
> Wyświetl średnie zarobki dla każdego ze stanowisk, o ile średnie te są większe od średnich zarobków w departamencie “Administracja”.
```sql
SELECT position_id, AVG(e.salary) avg_salary FROM employees e
JOIN positions p USING(position_id)
GROUP BY position_id
HAVING avg_salary > (
    SELECT AVG(e.salary) FROM employees e
    JOIN departments d USING(department_id)
    WHERE d.name = 'Administracja'
);
```

## Podzapytanie zwraca wiele wierszy danych
> Napisz zapytanie, które zwróci informacje o pracownikach zatrudnionych po zakończeniu wszystkich projektów (tabela projects). Zapytanie zrealizuj na 2 sposoby i porównaj wyniki
```sql
SELECT *
FROM employees WHERE date_employed > (
    SELECT MAX(date_end) FROM PROJECTS);

SELECT *
FROM employees
WHERE date_employed > ALL (
    SELECT DISTINCT date_end FROM projects WHERE date_end IS NOT NULL);
```
> Napisz zapytanie, które wyświetli wszystkich pracowników, których zarobki są co najmniej czterokrotnie większe od zarobków jakiegokolwiek innego pracownika.
```sql
SELECT * FROM employees
WHERE salary >= ANY (
    SELECT 4*salary FROM employees
);
```
> Korzystając z podzapytań napisz zapytanie które zwróci pracowników departamentów mających siedziby w Polsce.
```sql
SELECT * FROM employees
WHERE department_id IN (
    SELECT department_id FROM departments
    JOIN addresses USING(address_id)
    JOIN countries c USING(country_id)
    WHERE c.name = 'Polska'
);
```
> Zmodyfikuj poprzednie zapytania tak, żeby dodatkowo pokazać maksymalną pensję per departament.
```sql
SELECT department_id, MAX(salary) FROM employees
WHERE department_id IN (
    SELECT department_id FROM departments
    JOIN addresses USING(address_id)
    JOIN countries c USING(country_id)
    WHERE c.name = 'Polska'
)
GROUP BY department_id;
```

## Podzapytania skorelowane (`EXISTS` / `NOT EXISTS`)
> Napisz zapytanie, które zwróci pracowników zarabiających więcej niż średnia w ich departamencie.
```sql
SELECT e1.name, e1.surname, e1.salary
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);

```
> Napisz zapytanie które zwróci regiony nieprzypisane do krajów
```sql
SELECT *
FROM regions r
WHERE NOT EXISTS (
    SELECT * FROM countries
    JOIN reg_countries rg USING(country_id)
    WHERE rg.region_id = r.region_id
);
```
> Napisz zapytanie które zwróci kraje nieprzypisane do regionów
```sql
SELECT *
FROM countries c
WHERE NOT EXISTS (
    SELECT * FROM regions
    JOIN reg_countries rg USING(region_id)
    WHERE rg.country_id = c.country_id AND region_id IS NOT NULL
);
```
> Napisz zapytanie, które zwróci wszystkich pracowników niebędących managerami.
```sql
SELECT *
FROM employees e1
WHERE NOT EXISTS (
    SELECT * FROM employees e2
    WHERE e2.manager_id = e1.employee_id
);
```
> Napisz zapytanie, które zwróci dane pracowników, którzy zarabiają więcej niż średnie zarobki na stanowisku, na którym pracują
```sql
SELECT *
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary) FROM employees e2
    WHERE e2.position_id = e1.position_id
);
```
> Za pomocą podzapytania skorelowanego sprawdź, czy wszystkie stanowiska zdefiniowane w tabeli Positions są aktualnie zajęte przez pracowników.
```sql
SELECT *
FROM positions p
WHERE NOT EXISTS (
    SELECT * FROM employees e
    WHERE e.position_id = p.position_id
);
```

## Podzapytania w SELECT/FROM
> Napisz zapytanie, które dla wszystkich pracowników posiadających pensję zwróci informację o różnicy między ich pensją, a średnią pensją pracowników. Różnicę podaj jako zaokrągloną wartość bezwzględną.
```sql

```
> Korzystając z poprzedniego rozwiązania, napisz zapytanie, które zwróci tylko tych pracowników, którzy są kobietami i dla których różnica do wartości średniej jest powyżej 1000.
```sql

```
> Zmodyfikuj poprzednie zapytanie tak aby obliczyć liczbe pracowników. (skorzystaj z podzapytania)
```sql

```
> Napisz zapytanie które zwróci informacje o pracownikach zatrudnionych po zakończeniu wszystkich projektów (tabela projects). W wynikach zapytania umieść jako kolumnę datę graniczną.
```sql

```
> Napisz zapytanie które zwróci pracowników którzy uzyskali w 2019 oceny wyższe niż średnia w swoim departamencie. Pokaż średnią departamentu jako kolumnę.
```sql

```