-- Pakiety cwiczenia
--1,2
create or replace package emp_management
as
    function calculate_bonus(p_id number) return number;
end;
/
create or replace package body emp_management
as
    function calculate_bonus(p_id NUMBER)
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

    function create_login(emp_id number)
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
end;
/
select emp_management.calculate_bonus(101) from dual;
select emp_management.create_login(101) from dual;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------WYZWALACZE--------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--1
create or replace trigger tg_emp_salary
after update of salary on employees for each row
declare
    v_tax number;
    c_tax_coef constant number:=0.2;
begin
    v_tax := :new.salary * c_tax_coef;
    dbms_output.put_line('Podatek: ' || v_tax);
end;
/
update employees set salary = 2000 where employee_id = 101;
alter trigger tg_emp_salary DISABLE;
alter trigger tg_emp_salary ENABLE;
--2
create or replace trigger tg_emp_modify
after insert or delete or update of salary on employees
declare
    v_avg_salary number;
begin
    select avg(salary)
    into v_avg_salary
    from employees;

    dbms_output.put_line('?rednie zarobki: ' || v_avg_salary);
end;
/
update employees set salary = 2000 where employee_id = 101;
alter trigger tg_emp_modify DISABLE;
alter trigger tg_emp_modify ENABLE;

--3
select * from employees;
create or replace trigger tg_emp_manager_1
before insert on employees
for each row
when (new.department_id is not null and new.manager_id is null)
declare
    v_new_manager_id number;
begin
    select manager_id
    into v_new_manager_id
    from departments where department_id = :new.department_id;

    :new.manager_id := v_new_manager_id;
end;
/
insert into employees values(160, 'test', 'test', '30-OCT-80', 'M', 301, 3000, '01-FEB-05', 105, NULL, 105, NULL, '14-NOV-21');
alter trigger tg_emp_manager_1 DISABLE;
alter trigger tg_emp_manager_1 ENABLE;

--4
create or replace trigger tg_emp_manager_2
before insert on employees for each row
declare
    v_new_manager_id number;
begin
    if (:new.department_id is not null and :new.manager_id is null) then
            select manager_id
            into v_new_manager_id
            from departments where department_id = :new.department_id;

            :new.manager_id := v_new_manager_id;
    end if;
end;
/
insert into employees values(160, 'test', 'test', '30-OCT-80', 'M', 301, 3000, '01-FEB-05', 105, NULL, 105, NULL, '14-NOV-21');
alter trigger tg_emp_manager_2 DISABLE;
alter trigger tg_emp_manager_2 ENABLE;

--5
insert into positions values(118, 'Prezes', 15000, 30000);
select * from positions;
create or replace trigger tg_pos_director
before insert or update of position_id on employees
declare
    v_num_of_directors number;
begin
    select count(e.employee_id)
    into v_num_of_directors
    from employees e join positions p using(position_id)
    where p.name = 'Prezes';

    if v_num_of_directors >= 1 then
            raise_application_error(-20001, 'Wieciej niz jeden prezes');
    end if;
end;
/
select * from employees;
insert into employees values(161, 'test', 'test', '30-OCT-80', 'M', 301, 3000, '01-FEB-05', 105, NULL, 118, NULL, '14-NOV-21');
alter trigger tg_pos_director DISABLE;
alter trigger tg_pos_director ENABLE;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------KURSORY-----------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--PRZYKLAD KURSOR NIEJAWNYY
BEGIN
FOR r_emp IN (SELECT e.name as name, surname, p.name as position,
              d.name as department FROM employees e
              JOIN positions p USING (position_id) JOIN departments d USING (department_id))
LOOP
   dbms_output.put_line('Dane prac.: ' || r_emp.name || ' ' || r_emp.surname || ' ' || r_emp.position || ' ' || r_emp.department);
END LOOP;
END;
/
--PRZYKLAD KURSOR JAWNYY
DECLARE
    CURSOR cr IS
        SELECT * FROM employees;
    v_rec_employees employees%ROWTYPE;
BEGIN
    OPEN cr;
    LOOP
        EXIT WHEN cr%NOTFOUND;
        FETCH cr INTO v_rec_employees;
        dbms_output.put_line('Podstawowe dane pracownika: ' ||  v_rec_employees.name || ' ' ||
        v_rec_employees.surname || ' ' || v_rec_employees.salary || ' ' ||
        v_rec_employees.salary || ' ' || 'Podatek: ' || 0.2*v_rec_employees.salary);
    END LOOP;
    CLOSE cr;
END;
/
--CWICZENIA
--1
CREATE OR REPLACE PROCEDURE emp_info
as
    cursor cr is select department_id, avg(salary) from employees group by department_id;
    cursor cr_emp is select * from employees;
    v_employee employees%rowtype;
    v_department_id  number;
    v_avg_salary    number;
begin
    open cr_emp;
    loop
        exit when cr_emp%notfound;
        fetch cr_emp into v_employee;
        open cr;
        loop
            exit when cr%notfound;
            fetch cr into v_department_id, v_avg_salary;
            if (v_department_id = v_employee.department_id and v_employee.salary > v_avg_salary)
            then
                dbms_output.put_line(v_employee.name || ' ' || v_employee.surname || ' ' ||
                                     v_employee.salary);
            end if;
        end loop;
        close cr;
    end loop;
    close cr_emp;
end;
/
exec emp_info;

--2
create or replace procedure dept_info(p_no_dept number)
as
    cursor cr_dept is select * from departments
                      order by year_budget desc
                      fetch first p_no_dept rows with ties;
    v_department    departments%rowtype;
    v_manager employees%rowtype;
begin
    open cr_dept;
    loop
        exit when cr_dept%notfound;
        fetch cr_dept into v_department;
        dbms_output.put_line('Department id: ' || v_department.department_id);
        select * into v_manager
        from employees where employee_id = v_department.manager_id;

        dbms_output.put_line(v_manager.name);
        dbms_output.put_line('-------------------------------');

    end loop;
    close cr_dept;
end;
/
exec dept_info(4);


