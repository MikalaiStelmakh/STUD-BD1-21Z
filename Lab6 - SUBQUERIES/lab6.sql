-- SUBQUERIES

--1
SELECT e.employee_id, e.name, e.surname, e.salary, d.name
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
WHERE salary > (
    SELECT MIN(salary)
    FROM employees e JOIN positions p USING (position_id)
    WHERE p.name = 'Konsultant'
    );

-- or
SELECT e.employee_id, e.name, e.surname, e.salary, department_id, d.name
FROM employees e JOIN departments d USING (department_id);

--2
SELECT * FROM dependents
WHERE birth_date = (
    SELECT MAX(birth_date)
    FROM dependents
);

--3
SELECT *
FROM dependents
WHERE employee_id = (
    SELECT employee_id FROM employees
    WHERE position_id = 102
    ORDER BY birth_date FETCH FIRST ROW ONLY
    );

--4
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

--5
SELECT position_id, AVG(e.salary) avg_salary FROM employees e
JOIN positions p USING(position_id)
GROUP BY position_id
HAVING avg_salary > (
    SELECT AVG(e.salary) FROM employees e
    JOIN departments d USING(department_id)
    WHERE d.name = 'Administracja'
);

--1
SELECT *
FROM employees WHERE date_employed > (
    SELECT MAX(date_end) FROM PROJECTS);

SELECT *
FROM employees
WHERE date_employed > ALL (
    SELECT DISTINCT date_end FROM projects WHERE date_end IS NOT NULL);

--2
SELECT * FROM employees
WHERE salary >= ANY (
    SELECT 4*salary FROM employees
);

--3
SELECT * FROM employees
WHERE department_id IN (
    SELECT department_id FROM departments
    JOIN addresses USING(address_id)
    JOIN countries c USING(country_id)
    WHERE c.name = 'Polska'
);

--4
SELECT department_id, MAX(salary) FROM employees
WHERE department_id IN (
    SELECT department_id FROM departments
    JOIN addresses USING(address_id)
    JOIN countries c USING(country_id)
    WHERE c.name = 'Polska'
)
GROUP BY department_id;

--skorelowane, EXISTS, NOT EXISTS

--1
SELECT e1.name, e1.surname, e1.salary
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);

--2
SELECT *
FROM regions r
WHERE NOT EXISTS (
    SELECT * FROM countries
    JOIN reg_countries rg USING(country_id)
    WHERE rg.region_id = r.region_id
);

--3
SELECT *
FROM countries c
WHERE NOT EXISTS (
    SELECT * FROM regions
    JOIN reg_countries rg USING(region_id)
    WHERE rg.country_id = c.country_id AND region_id IS NOT NULL
);

--4
SELECT *
FROM employees e1
WHERE NOT EXISTS (
    SELECT *
    FROM employees e2
    WHERE e2.manager_id = e1.employee_id
);

--5
SELECT *
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary) FROM employees e2
    WHERE e2.position_id = e1.position_id
);

--6
SELECT *
FROM positions p
WHERE NOT EXISTS (
    SELECT * FROM employees e
    WHERE e.position_id = p.position_id
);

--podzapytania w SELECT/FROM
--1
SELECT e.name, e.surname, e.salary, ABS(e.salary - (SELECT ROUND(AVG(salary)) sal FROM employees))
FROM employees e
WHERE e.salary IS NOT NULL;

--2
SELECT e.name, e.surname, e.salary, e.gender, ABS(e.salary - a.sal) diff
FROM employees e, (SELECT ROUND(AVG(salary)) sal FROM employees WHERE gender = 'K') a
WHERE e.salary IS NOT NULL AND e.gender = 'K' AND ABS(e.salary - a.sal) > 1000;

--3
SELECT COUNT(*) FROM (
    SELECT e.name, e.surname, e.salary, e.gender, ABS(e.salary - a.sal) diff
    FROM employees e, (SELECT ROUND(AVG(salary)) sal FROM employees WHERE gender = 'K') a
    WHERE e.salary IS NOT NULL AND e.gender = 'K' AND ABS(e.salary - a.sal) > 1000
);

--4
SELECT *
FROM employees, (SELECT MAX(date_end) date_end FROM projects)
WHERE date_employed > date_end;

--5
SELECT e.employee_id, e.name, e.surname, AVG(g.grade), department_avg
FROM employees e
    LEFT JOIN emp_grades eg ON e.employee_id = eg.employee_id
    LEFT JOIN grades g ON g.grade_id = eg.grade_id
    JOIN (
        SELECT e2.department_id, AVG(g2.grade) department_avg
        FROM departments d
            JOIN employees e2 ON d.department_id = e2.department_id
            JOIN emp_grades eg2 ON eg2.employee_id = e2.employee_id
            JOIN grades g2 ON g2.grade_id = eg2.grade_id
        WHERE EXTRACT(YEAR FROM eg2.inspection_date) = 2019
        GROUP BY e2.department_id
    ) USING (department_id)
WHERE EXTRACT(YEAR FROM eg.inspection_date) = 2019
GROUP BY e.employee_id, e.name, e.surname, department_avg
HAVING AVG(g.grade) > department_avg;
















