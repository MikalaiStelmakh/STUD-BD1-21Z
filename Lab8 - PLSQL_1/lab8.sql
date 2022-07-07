-- Blok anonimowy[1]
--1
begin
    NULL;
end;
/
--2
begin
    dbms_output.put_line('Hello World!');
end;
/
--3
begin
    insert into regions values(NULL, 'Oceania', 'OC', 'active');
end;
/
--4
--begin
--    RAISE_APPLICATION_ERROR(-20000, 'Account past due.');
--end;
--/
-- Zmienne przyklad
DECLARE
    v_id       NUMBER := 102;
    v_name     VARCHAR2 (50);
    v_surname  employees.surname%TYPE;
    v_employee employees%ROWTYPE;
    c_magic CONSTANT NUMBER := 10;
BEGIN
    dbms_output.put_line('Employee with id '|| v_id|| ' has name '|| v_name || ' '|| v_surname);

    SELECT name, surname
    INTO   v_name, v_surname
    FROM   employees
    WHERE  employee_id = v_id;

    dbms_output.put_line('Employee with id '|| v_id|| ' has name '|| v_name || ' '|| v_surname);

    v_id := v_id + length(v_surname) + c_magic;

    SELECT *
    INTO   v_employee
    FROM   employees
    WHERE  employee_id = v_id;

    dbms_output.put_line('Employee with id '|| v_id|| ' has name '|| v_employee.name || ' '|| v_employee.surname);

    INSERT INTO countries(country_id,name,capital) VALUES (130,'Islandia','Reykjavík');
END;
/
--Blok anonimowy[2]
--1
--select * from employees;
declare
    v_min_sal number:=2000;
    v_emp_id number:=101;
    v_emp_name  employees.name%TYPE;
    v_emp_surname  employees.surname%TYPE;
    v_emp_salary number;
begin
    select name, surname, salary
    into v_emp_name, v_emp_surname, v_emp_salary
    from employees
    where employee_id = v_emp_id and salary > v_min_sal;
    if v_emp_name is not null then
        dbms_output.put_line(v_emp_name || ' ' || v_emp_surname || ' salary: ' || v_emp_salary);
    end if;
end;
/
--Funkcje przyklad
CREATE OR replace FUNCTION calculate_seniority_bonus(p_id NUMBER)
RETURN NUMBER
AS
  v_age           NUMBER;
  v_yrs_employed  NUMBER;
  v_birth_date    DATE;
  v_date_employed DATE;
  v_salary        NUMBER;
  v_bonus         NUMBER := 0;
  c_sal_multiplier CONSTANT NUMBER := 2;
  c_age_min CONSTANT NUMBER := 30;
  c_emp_min CONSTANT NUMBER := 3;
BEGIN
    SELECT birth_date,date_employed, salary
    INTO   v_birth_date, v_date_employed, v_salary
    FROM   employees
    WHERE  employee_id = p_id;

    v_age := extract (year FROM SYSDATE) - extract (year FROM v_birth_date);
    v_yrs_employed := extract (year FROM SYSDATE) - extract (year FROM v_date_employed);

    IF v_age > c_age_min AND v_yrs_employed > c_emp_min THEN
      v_bonus := c_sal_multiplier * v_salary;
    END IF;
    RETURN v_bonus;
END;
/
select e.*, calculate_seniority_bonus(e.employee_id) from employees e;

--Funkcje cwiczenia
--1
create or replace function calculate_year_tax(e_id number)
return number
as
    v_emp_salary number;
    v_tax number;
    c_default_tax_coef constant number:=0.15;
    c_increased_tax_coef constant number:=0.25;
    c_limit constant number:= 100000;
begin
    select salary
    into v_emp_salary
    from employees
    where employee_id = e_id;
    
    if v_emp_salary*c_default_tax_coef <= c_limit then
        v_tax := v_emp_salary*c_default_tax_coef;
    else
        v_tax := v_emp_salary*c_increased_tax_coef;
    end if;
    return v_tax;
end;
/
--2
create or replace function calculate_bonus(v_manager_id number)
return number
as
    v_manager_salary number;
    v_number_of_employees number;
    v_max_bonus number;
    v_bonus number;
    c_bonus_coef_for_employee constant number:=0.1;
    c_max_bonus_to_salary_coef constant number:=0.5;
begin
    select count(e.employee_id) 
    into v_number_of_employees
    from departments d join employees e 
    using(department_id) group by d.manager_id having(d.manager_id = v_manager_id);
    
    v_bonus := v_number_of_employees*c_bonus_coef_for_employee;
    
    select salary
    into v_manager_salary
    from employees
    where employee_id = manager_id;

    v_max_bonus := v_manager_salary*c_max_bonus_to_salary_coef;
    if v_bonus > v_max_bonus then
        v_bonus := v_max_bonus;
    end if;

    return v_bonus;
end;
/
--Procedury
--1
create or replace procedure change_employee_department(e_id number, p_id number)
as
begin
    update employees set position_id = p_id where employee_id = e_id;
end;
/
--3
select * from departments;
select * from employees;

create or replace procedure change_manager(m_id number)
as
    v_new_manager_id number;
    v_department_id number;
begin
    select department_id
    into v_department_id
    from departments where manager_id = m_id;
    
    select employee_id
    into v_new_manager_id
    from employees where department_id = v_department_id
    order by (extract(year from sysdate)-extract(year from birth_date)) desc
    fetch first row only;
    
    update departments set manager_id = v_new_manager_id where department_id = v_department_id;
end;
/
-- Praca domowa
--1
create or replace function create_login(emp_id number)
return varchar2
as
    v_emp_name employees.name%type;
    v_emp_surname employees.surname%type;
    v_surname_as_login varchar(7);
    v_login varchar2(10);
    c_max_surname_chars constant number:=7;
begin
    select name, surname
    into v_emp_name, v_emp_surname
    from employees where employee_id = emp_id;
    
    if length(v_emp_surname) > c_max_surname_chars then
        v_surname_as_login := substr(v_emp_surname, 1, c_max_surname_chars);
    else
        v_surname_as_login := v_emp_surname;
    end if;
    v_login := lower(substr(v_emp_name, 1, 1)) || lower(v_surname_as_login);
    return v_login;
end;
/
select * from employees;
select create_login(101) from dual;
    
    

