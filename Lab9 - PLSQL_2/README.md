# Bazy Danych - Laboratorium 9 (PLSQL)
## Pakiety
> Uzupełnij ciało pakietu z poprzedniego slajdu za pomocą definicji funkcji calculate_seniority_bonus oraz procedury add_candidate, które pojawiły się na poprzednich zajęciach. Następnie wywołaj te podprogramy z wykorzystaniem nazwy pakietu.

> Dodaj do pakietu prywatną funkcję create_base_login, która będzie generowała bazowy login pracownika (ćwiczenie z pracy domowej BD1_8). Sprawdź możliwość wywołania tej funkcji.
```sql
CREATE OR REPLACE PACKAGE emp_management
AS
    FUNCTION calculate_seniority_bonus (p_id NUMBER) RETURN NUMBER;
    PROCEDURE add_candidate (p_name VARCHAR2, p_surname VARCHAR2, p_birth_date DATE, p_gender VARCHAR2, p_pos_name VARCHAR2, p_dep_name VARCHAR2);
    FUNCTION create_base_login(emp_id number) RETURN VARCHAR2;
END;
/

CREATE OR REPLACE PACKAGE BODY emp_management
AS
    FUNCTION calculate_seniority_bonus(p_id NUMBER) RETURN NUMBER
    AS
        v_age NUMBER;
        v_yrs_employed NUMBER;
        v_birth_date DATE;
        v_date_employed DATE;
        v_salary NUMBER;
        v_bonus NUMBER := 0;
        c_sal_multiplier CONSTANT NUMBER := 2;
        c_age_min CONSTANT NUMBER := 30;
        c_emp_min CONSTANT NUMBER := 3;
    BEGIN
        SELECT birth_date,date_employed, salary
        INTO v_birth_date, v_date_employed, v_salary
        FROM employees
        WHERE employee_id = p_id;

        v_age := extract (year FROM SYSDATE) - extract (year FROM v_birth_date);
        v_yrs_employed := extract (year FROM SYSDATE) - extract (year FROM v_date_employed);

        IF v_age > c_age_min AND v_yrs_employed > c_emp_min THEN
            v_bonus := c_sal_multiplier * v_salary;
        END IF;

        RETURN v_bonus;
    END calculate_seniority_bonus;

    PROCEDURE add_candidate (p_name VARCHAR2, p_surname VARCHAR2, p_birth_date DATE,
        p_gender VARCHAR2, p_pos_name VARCHAR2, p_dep_name VARCHAR2)
    AS
        v_pos_id NUMBER;
        v_dep_id NUMBER;
        v_cand_num NUMBER;
        c_candidate_status CONSTANT NUMBER := 304;
        c_num_max CONSTANT NUMBER := 2;
    BEGIN
        SELECT position_id INTO v_pos_id FROM positions WHERE name = p_pos_name;
        SELECT department_id INTO v_dep_id FROM departments WHERE name = p_dep_name;

        SELECT count(employee_id) INTO v_cand_num
        FROM employees
        WHERE department_id = v_dep_id AND status_id = c_candidate_status;
        IF v_cand_num < c_num_max THEN
            INSERT INTO employees
            VALUES (NULL, p_name, p_surname, p_birth_date, p_gender, c_candidate_status, NULL, NULL, v_dep_id, v_pos_id, NULL);
            dbms_output.put_line ('Dodano kandydata '|| p_name|| ' '|| p_surname);
        ELSE
            dbms_output.put_line ('Za duzo kandydatów w departamencie: '|| p_dep_name);
        END IF;
    EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line ('Niepoprawna nazwa stanowiska i/lub zakładu');
        RAISE;
    WHEN too_many_rows THEN
        dbms_output.put_line ('Nieunikalna nazwa stanowiska i/lub zakładu');
        RAISE;
    END add_candidate;

    FUNCTION create_base_login(p_id NUMBER)
    RETURN VARCHAR2
    AS
        v_login VARCHAR2(8 CHAR);
    BEGIN
        SELECT SUBSTR(name, 1, 1) || SUBSTR(surname, 1, 7)
        INTO v_login
        FROM employees
        WHERE employee_id = p_id;

        RETURN v_login;
    END create_base_login;

END emp_management;


SELECT emp_management.calculate_seniority_bonus(101) FROM dual;
SELECT emp_management.create_base_login(101) FROM dual;
```

## Wyzwalacze
> Stwórz wyzwalacz, który podczas uaktualniania zarobków pracownika wyświetli podatek 20% procent od nowych zarobków. Przetestuj działanie.
```sql
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
```
> Stwórz wyzwalacz, który po dodaniu nowego pracownika, usunięciu pracownika lub modyfikacji zarobków pracowników wyświetli aktualne średnie zarobki wszystkich pracowników. Przetestuj działanie.
```sql
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
```
> Stwórz wyzwalacz, który dla każdego nowego pracownika nieposiadającego managera, ale zatrudnionego w departamencie, przypisze temu pracownikowi managera będącego jednocześnie managerem departamentu, w którym ten pracownik pracuje. Wykorzystaj klauzulę WHEN wyzwalacza. Przetestuj działanie.
```sql
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
```
> Rozwiąż ponownie ćwiczenie nr 4, ale tym razem nie wykorzystuj klauzuli WHEN wyzwalacza. Przetestuj działanie.
```sql
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
```
> Stwórz wyzwalacz który będzie weryfikował, że w firmie pracuje tylko jeden Prezes.
```sql
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
```

## Kursory
> Przygotuj procedurę PL/SQL, która z wykorzystaniem jawnego kursora udostępni średnie zarobki dla każdego z departamentów. Następnie wykorzystując ten kursor wyświetl imiona, nazwiska i zarobki pracowników, którzy zarabiają więcej niż średnie zarobki w ich departamentach.
```sql
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
```
> Przygotuj procedurę PL/SQL, która z wykorzystaniem jawnego kursora wyświetli p_no_dept departamenty największych budżetach, gdzie p_no_dept to parametr wejściowy procedury. Następnie wyświetl dane kierowników tych departamentów.
```sql
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
```
> Wykorzystując niejawny kursor oraz deklaracje zmiennych/stałych podnieś o 2% pensje wszystkim pracownikom zatrudnionym w przeszłości (tzn. przed aktualnym stanowiskiem pracy) na co najmniej jednym stanowisku pracy.
```sql
DECLARE
    c_rise CONSTANT NUMBER := 1.02;
BEGIN
    FOR v_emp IN (SELECT * FROM employees e WHERE EXISTS(SELECT * FROM positions_history ph WHERE ph.employee_id = e.employee_id) AND salary IS NOT NULL)
    LOOP
        UPDATE employees
        SET salary = v_emp.salary * c_rise
        WHERE employee_id = v_emp.employee_id;
    END LOOP;
END;
/

SELECT * FROM employees e WHERE EXISTS(SELECT * FROM positions_history ph WHERE ph.employee_id = e.employee_id) AND salary IS NOT NULL;

```