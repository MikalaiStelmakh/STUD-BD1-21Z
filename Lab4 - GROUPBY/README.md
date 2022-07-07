# Bazy Danych - Laboratorium 4 (GROUP BY)
## Polecenie `GROUP BY`
> Przygotuj zapytanie, które wyświetli informację ilu pracowników ma aktualnie dany status_id (Status_ID odwołujący się do tabeli EMP_STATUS).
```sql
SELECT COUNT(*), status_id
FROM employees
GROUP BY status_id;
```
> Zmodyfikuj poprzednie zapytanie, żeby pokazać jedynie liczbę kobiet będących w danym statusie.
```sql
SELECT COUNT(*), status_id
FROM employees
WHERE gender = 'K'
GROUP BY status_id;
```
> Wyświetl minimalne, maksymalne zarobki, a także średnią, medianę i odchylenie standardowe zarobków pracowników na każdym ze stanowisk (wykorzystaj tylko tabelę Employees).
```sql
SELECT MIN(salary), MEDIAN(salary), MAX(salary), STDDEV(salary)
FROM employees
GROUP BY department_id;
```
> Napisz zapytanie, które dla określonego języka zwróci: liczbę krajów które używają tego języka, średnią populację.
```sql
SELECT COUNT(*), AVG(population)
FROM countries
GROUP BY language;
```
> Dla każdej z płci oblicz średnią pensję, średni wiek oraz średnią długość zatrudnienia. Wyniki posortuj względem średniej pensji malejąco.
```sql
SELECT AVG(salary)
FROM employees
GROUP BY gender
ORDER BY AVG(salary) DESC;
```
> Oblicz liczbę założonych departamentów w każdym roku.
```sql
SELECT COUNT(*) count, EXTRACT(YEAR FROM established) established
FROM departments
GROUP BY EXTRACT(YEAR FROM established);
```
> Oblicz liczbę pracowników zatrudnionych każdego miesiąca(sty, lu, ma..)
```sql
SELECT COUNT(*) count, EXTRACT(MONTH FROM date_employed) "month"
FROM employees
GROUP BY EXTRACT(MONTH FROM date_employed)
ORDER BY EXTRACT(MONTH FROM date_employed) ASC;
```
## Klauzula `HAVING`
> Wyświetl informacje o liczbie krajów mających dany język jako urzędowy. Pokaż języki które są wykorzystane przez przynajmniej  2 kraje.
```sql
SELECT COUNT(*) "number", language "lang"
FROM countries
GROUP BY language
HAVING COUNT(language) >= 2;
```
> Wyświetl średnie zarobki dla każdego ze stanowisk, o ile średnie te są większe od 2000.
```sql
SELECT * FROM employees;
SELECT AVG(salary), department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 2000;
```
> Wyświetl średnie zarobki dla każdego ze stanowisk, o ile średnie te są większe od 2000 i liczba pracowników na danym stanowisku jest większa niż 1.
```sql
SELECT AVG(salary), department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 2000 AND COUNT(*) > 1;
```
> Wyświetl średnie zarobki dla wszystkich pracowników pogrupowane ze względu na kolumny Department_ID, Status_ID, o ile ich Status_ID = 301 lub 304.
```sql
SELECT AVG(salary), department_id, status_id
FROM employees
GROUP BY department_id, status_id
HAVING status_id IN (301, 304);
```
## Operatory `UNION`, `INTERSECT`, `MINUS`
> Napisz polecenie które zwróci nazwę regionu i jego nazwę skróconą oraz nazwę kraju oraz jego nazwę skróconą. Rozróżnij regiony od krajów dodając kolumnę rodzaj przyjmującą wartości “R” dla regionów i “K” dla krajów.
```sql
SELECT name,shortname, 'R' region_or_country
FROM regions
UNION
SELECT name, code, 'C'
FROM countries;
```
> Napisz polecenie które zwróci imię nazwisko i wiek pracowników oraz imię, nazwisko i wiek dzieci pracowników. Rozróżnij pracowników od dzieci dodając kolumnę rodzaj przyjmującą wartości “P” dla pracowników i “D” dla dzieci.
```sql
SELECT name, surname, ROUND(MONTHS_BETWEEN(SYSDATE, birth_date)/12, 0) age, 'E' "Employee or Child"
FROM employees
UNION
SELECT name, surname, ROUND(MONTHS_BETWEEN(SYSDATE, birth_date)/12, 0), 'C'
FROM dependents;
```
> Korzystając z operatora UNION napisz zapytanie, które zwróci id, imię i nazwisko wszystkich pracowników pracujących w zakładzie o ID = 101 lub na stanowisku o ID = 103. (Jak mozna to inaczej zapisac? Jak myslisz która wersja jest wydajniejsza?)
```sql
SELECT * FROM employees;
SELECT employee_id, name, surname, department_id, position_id
FROM employees
WHERE department_id = 101 OR position_id = 103;

-- Druga wersja
SELECT employee_id, name, surname, 'D' "Department_id=101 Or Position_id=103"
FROM employees
WHERE department_id = 101
UNION
SELECT employee_id, name, surname, 'E'
FROM employees
WHERE position_id = 103;
```
> Korzystając z operatora INTERSECT pokaż nazwy wszystkich stanowisk, które rozpoczynają się od liter P, K lub A, a minimalne zarobki (według tabeli POSITIONS) są dla nich większe lub równe 1500.
```sql
SELECT name FROM positions
WHERE name LIKE 'P%' OR name LIKE 'K%' OR name LIKE 'A%'
INTERSECT
SELECT name FROM positions WHERE min_salary >= 1500;
```
> Z zastosowaniem operatora MINUS wyświetl średnie zarobki (dla tabeli Employees) dla wszystkich stanowisk z wyłączeniem stanowiska o ID = 102. Posortuj rezultat malejąco według średnich zarobków.
```sql
SELECT AVG(salary) avg_salary, position_id FROM employees
GROUP BY position_id
MINUS
SELECT AVG(salary), position_id FROM employees
GROUP BY position_id
HAVING position_id = 102
ORDER BY avg_salary DESC NULLS LAST;
```