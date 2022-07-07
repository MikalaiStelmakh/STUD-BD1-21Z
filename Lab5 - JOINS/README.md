# Bazy Danych - Laboratorium 5 (JOINS)
## Złączenie `CROSS JOIN`
> Pokaż wszystkie kombinacje pracowników (employees) oraz uzyskanych
ocen z oceny rocznej (grades). Pokaż identyfikator pracownika oraz ocenę
liczbową i jej opis.
```sql
SELECT employee_id, grade, description
FROM employees CROSS JOIN grades;
```
> Zmodyfikuj poprzednie zapytanie tak aby pokazać tylko pracowników z
departamentów 101, 102, 103 lub bez departamentu.
```sql
SELECT employee_id, grade, description
FROM employees CROSS JOIN grades
WHERE department_id IN (101, 102, 103) OR department_id IS NULL;
```

## Złączenia `INNER JOIN` / `NATURAL JOIN`
> Znajdź pracowników, których zarobki nie są zgodne z “widełkami” na jego
stanowisku. Zwróć imię, nazwisko, wynagrodzenie oraz nazwę stanowiska.
```sql
SELECT e.name, e.surname, e.salary, p.name
FROM employees e JOIN positions p USING (position_id)
WHERE e.salary NOT BETWEEN min_salary AND max_salary;
```
> Zmodyfikuj poprzednie zapytanie tak, aby dodatkowo wyświetlić informacje
o nazwie zakładu pracownika.
```sql
SELECT e.name, e.surname, e.salary, p.name, d.name
FROM employees e JOIN positions p USING (position_id)
JOIN departments d USING (department_id)
WHERE e.salary NOT BETWEEN min_salary AND max_salary;
```
> Wyświetl nazwę zakładu wraz z imieniem i nazwiskiem jego kierowników.
Pokaż tylko zakłady, które mają budżet pomiędzy 5000000 i 10000000.
```sql
SELECT d.name, e.name, e.surname FROM departments d
JOIN employees e ON (d.manager_id = e.employee_id)
WHERE d.year_budget BETWEEN (5000000 AND 10000000);
```
> Znajdź zakłady (podaj ich nazwę), które mają swoje siedziby w Polsce.
```sql
SELECT d.name FROM departments d
JOIN addresses a USING(address_id)
JOIN countries c USING(country_id)
WHERE c.name = 'Polska';
```
> Zmodyfikuj zapytanie 3 tak, aby uwzględniać w wynikach tylko zakłady,
które mają siedziby w Polsce.
```sql
SELECT d.name, e.name, e.surname FROM departments d
JOIN employees e ON (d.manager_id = e.employee_id)
JOIN addresses a USING(address_id)
JOIN countries c USING(country_id)
WHERE
    d.year_budget BETWEEN (5000000 AND 10000000)
    AND
    c.name = 'Polska';
```
> Pokaż oceny (grades) pracowników którzy nie posiadają kierownika. W
wynikach pokaż imie , nazwisko pracownika, ocene liczbowa i jej opis.
```sql
SELECT e.name, e.surname, g.grade, g.description FROM employees e
JOIN emp_grades USING(employee_id)
JOIN grades g USING(grade_id)
WHERE e.manager_id IS NULL;
```
> Pokaż nazwę kraju i nazwę regionu do którego został przypisany.
```sql
SELECT c.name, r.name FROM reg_countries
NATURAL JOIN regions r
JOIN countries c USING (country_id);
```

## Złączenia `OUTER JOIN` / `FULL JOIN`
> Wyświetl listę zawierającą nazwisko pracownika, stanowisko, na którym
pracuje, aktualne zarobki oraz widełki płacowe dla tego stanowiska.
Sterując rodzajem złączenia, zagwarantuj, że w wynikach znajdą się
wszyscy pracownicy.
```sql
SELECT e.surname, p.name, e.salary, p.min_salary, p.max_salary FROM employees e
LEFT JOIN positions p USING(position_id);
```
> Wyświetl średnią pensję oraz liczbę osób zatrudnionych dla stanowisk.
Sterując rodzajem złączenia zagwarantuj, że znajdą się tam również
stanowiska, na których nikt nie jest zatrudniony.
```sql
SELECT AVG(e.salary), COUNT(e.employee_id) FROM positions p
LEFT OUTER JOIN employees e USING (position_id)
GROUP BY position_id, p.name;
```
> Pokaż liczbę pracowników zatrudnionych kiedykolwiek w każdym projekcie.
Zadbaj by w wynikach pojawił się każdy projekt.
```sql
SELECT project_id, p.name, COUNT(employee_id) FROM employees e
JOIN emp_projects USING(employee_id)
RIGHT JOIN projects p USING(project_id)
GROUP BY project_id, p.name;
```
> Pokaż średnią ocenę pracowników per departament. W wynikach zamiesc
nazwe departamentu i srednia ocene.
```sql
SELECT d.name, AVG(g.grade) FROM grades g
JOIN emp_grades USING (grade_id)
JOIN employees e USING (employee_id)
RIGHT JOIN departments d USING (department_id)
GROUP BY department_id, d.name;
```

## Złączenia `NON EQUI JOIN` / `SELF JOIN`
> Dla każdego imienia pracownika z zakładów Administracja lub Marketing zwróć
liczbę pracowników, którzy mają takie samo imię i podaj ich średnie zarobki.
```sql
SELECT e.name, COUNT(e.name)-1, AVG(e.salary) FROM employee e
JOIN departments d USING(department_id)
WHERE d.name IN ('Administracja', 'Marketing')
GROUP BY e.name
HAVING COUNT(e.name) > 1;
```
> Zwróć imiona i nazwiska pracowników, którzy przeszli więcej niż 2 zmiany
stanowiska. Wyniki posortuj malejąco wg liczby zmian.
```sql
SELECT e.name, e.surname, COUNT(*) n_changes FROM employees e
JOIN positions_history USING(employee_id)
GROUP BY (employee_id, e.name, e.surname)
HAVING COUNT(*) > 2
ORDER BY n_changes DESC;
```
> Zwróć id, nazwisko kierowników oraz liczbę podległych pracowników. Wyniki
posortuj malejąco wg liczby podległych pracowników.
```sql
SELECT m.employee_id, m.name, m.surname, COUNT(*) FROM employees e
JOIN employees m ON (m.employee_id = e.manager_id)
GROUP BY m.employee_id, m.name, m.surname
ORDER BY COUNT(*) DESC;
```
> Napisz zapytanie zwracające liczbę zakładów w krajach. W wynikach podaj
nazwę kraju oraz jego ludność.
```sql
SELECT c.name, c.population, COUNT(*) Departments FROM departments d
JOIN addresses a USING (address_id)
RIGHT JOIN countries c USING (country_id)
GROUP BY country_id, c.name, c.population;
```
> Napisz zapytanie zwracające liczbę zakładów w regionach. W wynikach podaj
nazwę regionu. Wynik posortuj malejąco względem liczby zakładów.
```sql
SELECT r.name, COUNT(*) Departments FROM departments d
JOIN addresses a USING (address_id)
RIGHT JOIN countries c USING (country_id)
RIGHT JOIN reg_countries USING (country_id)
RIGHT JOIN regions r USING (region_id)
GROUP BY region_id, r.name
ORDER BY COUNT(*) DESC;
```