SELECT AVG(salary), department_id
FROM employees
GROUP BY department_id;

SELECT AVG(salary), department_id, position_id
FROM employees
GROUP BY department_id, position_id;

-- GROUP BY
--1
SELECT COUNT(*), status_id
FROM employees
GROUP BY status_id;

--2
SELECT COUNT(*), status_id
FROM employees
WHERE gender = 'K'
GROUP BY status_id;

--3
SELECT MIN(salary), MEDIAN(salary), MAX(salary), STDDEV(salary)
FROM employees
GROUP BY department_id;

--4
SELECT COUNT(*), AVG(population)
FROM countries
GROUP BY language;

--5
SELECT AVG(salary)
FROM employees
GROUP BY gender
ORDER BY AVG(salary) DESC;

--6
SELECT COUNT(*) count, EXTRACT(YEAR FROM established) established
FROM departments
GROUP BY EXTRACT(YEAR FROM established);

--7
SELECT COUNT(*) count, EXTRACT(MONTH FROM date_employed) "month"
FROM employees
GROUP BY EXTRACT(MONTH FROM date_employed)
ORDER BY EXTRACT(MONTH FROM date_employed) ASC;

--HAVING
SELECT AVG(salary), department_id, position_id
FROM employees
GROUP BY department_id, position_id
HAVING position_id IN (101, 103);

--1
SELECT COUNT(*) "number", language "lang"
FROM countries
GROUP BY language
HAVING COUNT(language) >= 2;

--2
SELECT * FROM employees;
SELECT AVG(salary), department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 2000;

--3
SELECT AVG(salary), department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 2000 AND COUNT(*) > 1;

--4
SELECT AVG(salary), department_id, status_id
FROM employees
GROUP BY department_id, status_id
HAVING status_id IN (301, 304);

--UNION, INTERSECT, MINUS
SELECT AVG(salary) avg_sal, manager_id
FROM employees
GROUP BY manager_id
MINUS
SELECT AVG(salary) avg_sal, manager_id
FROM employees
GROUP BY manager_id
HAVING manager_id IS NULL
ORDER BY avg_sal;

--1
SELECT name,shortname, 'R' region_or_country
FROM regions
UNION
SELECT name, code, 'C'
FROM countries;

--2
SELECT name, surname, ROUND(MONTHS_BETWEEN(SYSDATE, birth_date)/12, 0) age, 'E' "Employee or Child"
FROM employees
UNION
SELECT name, surname, ROUND(MONTHS_BETWEEN(SYSDATE, birth_date)/12, 0), 'C'
FROM dependents;

--3
SELECT * FROM employees;
SELECT employee_id, name, surname, department_id, position_id
FROM employees
WHERE department_id = 101 OR position_id = 103;

SELECT employee_id, name, surname, 'D' "Department_id=101 Or Position_id=103"
FROM employees
WHERE department_id = 101
UNION
SELECT employee_id, name, surname, 'E'
FROM employees
WHERE position_id = 103;

--4
SELECT name FROM positions
WHERE name LIKE 'P%' OR name LIKE 'K%' OR name LIKE 'A%'
INTERSECT
SELECT name FROM positions WHERE min_salary >= 1500;

--5
SELECT AVG(salary) avg_salary, position_id FROM employees
GROUP BY position_id
MINUS
SELECT AVG(salary), position_id FROM employees
GROUP BY position_id
HAVING position_id = 102
ORDER BY avg_salary DESC NULLS LAST;

