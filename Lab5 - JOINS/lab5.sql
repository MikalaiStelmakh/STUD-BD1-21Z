--JOINS

-- CROSS JOIN
--1
SELECT employee_id, grade, description
FROM employees CROSS JOIN grades;

--2
SELECT employee_id, grade, description
FROM employees CROSS JOIN grades
WHERE department_id IN (101, 102, 103) OR department_id IS NULL

-- INNER JOIN, NATURAL JOIN

--1
SELECT e.name, e.surname, e.salary, p.name
FROM employees e JOIN positions p USING (position_id)
WHERE e.salary NOT BETWEEN min_salary AND max_salary;

--2
SELECT e.name, e.surname, e.salary, p.name, d.name
FROM employees e JOIN positions p USING (position_id)
JOIN departments d USING (department_id)
WHERE e.salary NOT BETWEEN min_salary AND max_salary;

--3
SELECT d.name, e.name, e.surname
FROM departments d JOIN employees e
ON (d.manager_id = e.employee_id)
WHERE d.year_budget BETWEEN (5000000 AND 10000000);

--4
SELECT d.name FROM departments d
JOIN addresses a USING(address_id)
JOIN countries c USING(country_id)
WHERE c.name = 'Polska';

--5
SELECT d.name, e.name, e.surname FROM departments d
JOIN employees e ON (d.manager_id = e.employee_id)
JOIN addresses a USING(address_id)
JOIN countries c USING(country_id)
WHERE
    d.year_budget BETWEEN (5000000 AND 10000000)
    AND
    c.name = 'Polska';

--6
SELECT e.name, e.surname, g.grade, g.description FROM employees e
JOIN emp_grades USING(employee_id)
JOIN grades g USING(grade_id)
WHERE e.manager_id IS NULL;

--7
SELECT c.name, r.name FROM reg_countries NATURAL JOIN regions r
JOIN countries c USING (country_id);

-- OUTER JOIN, FULL JOIN
--1
SELECT e.surname, p.name, e.salary, p.min_salary, p.max_salary FROM employees e
LEFT JOIN positions p USING(position_id);

--2
SELECT AVG(e.salary), COUNT(e.employee_id) FROM positions p
LEFT OUTER JOIN employees e USING (position_id)
GROUP BY position_id, p.name;

--3
SELECT project_id, p.name, COUNT(employee_id) FROM employees e
JOIN emp_projects USING(employee_id)
RIGHT JOIN projects p USING(project_id)
GROUP BY project_id, p.name;

--4


-- NONEQUI, SELF JOIN
--1
SELECT e.name, COUNT(e.name)-1, AVG(e.salary) FROM employee e
JOIN departments d USING(department_id)
WHERE d.name IN ('Administracja', 'Marketing')
GROUP BY e.name
HAVING COUNT(e.name) > 1;

--2
SELECT e.name, e.surname, COUNT(*) n_changes FROM employees e
JOIN positions_history USING(employee_id)
GROUP BY (employee_id, e.name, e.surname)
HAVING COUNT(*) > 2
ORDER BY n_changes DESC;

--3
SELECT m.employee_id, m.name, m.surname, COUNT(*) FROM employees e
JOIN employees m ON (m.employee_id = e.manager_id)
GROUP BY m.employee_id, m.name, m.surname
ORDER BY COUNT(*) DESC;

--4
SELECT c.name, c.population, COUNT(*) Departments FROM departments d
JOIN addresses a USING (address_id)
RIGHT JOIN countries c USING (country_id)
GROUP BY country_id, c.name, c.population;

--5
SELECT r.name, COUNT(*) Departments FROM departments d
JOIN addresses a USING (address_id)
RIGHT JOIN countries c USING (country_id)
RIGHT JOIN reg_countries USING (country_id)
RIGHT JOIN regions r USING (region_id)
GROUP BY region_id, r.name
ORDER BY COUNT(*) DESC;
