# Bazy Danych - Laboratorium 8 (PLSQL)
## Blok anonimowy
> Napisz prosty blok anonimowy zawierający blok wykonawczy z instrukcją NULL. Uruchom ten program.
```sql
begin
    NULL;
end;
```
> Zmodyfikuj program powyżej i wykorzystaj procedurę dbms_output.put_line przyjmującą jako parametr łańcuch znakowy do wyświetlenia na konsoli. Uruchom program i odnajdź napis.
```sql
begin
    dbms_output.put_line('Hello World!');
end;
```
> Napisz blok anonimowy który doda do tabeli region nowy rekord (np. ‘Oceania’). Uruchom program i zweryfikuj działanie.
```sql
begin
    insert into regions values(NULL, 'Oceania', 'OC', 'active');
end;
```
> Napisz blok anonimowy, który wygeneruje błąd (RAISE_APPLICATION_ERROR przyjmującą 2 parametry: kod błędu oraz wiadomość)
```sql
BEGIN
    RAISE_APPLICATION_ERROR(-20000, 'Message');
END;
```

> Napisz blok anonimowy który będzie korzystał z dwóch zmiennych (v_min_sal oraz v_emp_id) i który będzie wypisywał na ekran imię i nazwisko pracownika o wskazanym id tylko jeśli  jego zarobki są wyższe niż v_min_sal.
```sql
DECLARE
    v_min_sal NUMBER := 100;
    v_emp_id NUMBER := 101;
    v_employee employees%ROWTYPE;
BEGIN

    SELECT *
    INTO v_employee
    FROM employees
    WHERE employee_id = v_emp_id;

    IF v_employee.salary > v_min_sal THEN
        dbms_output.put_line( 'Employee with id '|| v_emp_id|| ' has name '|| v_employee.name || ' '|| v_employee.surname);
    END IF;

END;

```

## Funkcje
> Napisz funkcję, która wyliczy roczną wartość podatku pracownika. Zakładamy podatek progresywny. Początkowo stawka to 15%, po przekroczeniu progu 100000 stawka wynosi 25%.
```sql
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
```
> Stwórz widok łączący departamenty, adresy i kraje. Napisz zapytanie, które pokaże sumę zapłaconych podatków w krajach.
```sql
CREATE OR REPLACE VIEW departments_addresses_countries AS
    SELECT d.department_id, c.country_id, c.name
    FROM departments d
        JOIN addresses a ON d.address_id = a.address_id
        JOIN countries c ON a.country_id = c.country_id;

SELECT d.name, SUM(YEAR_TAX(e.employee_id))
FROM departments_addresses_countries d
JOIN employees e USING (department_id)
GROUP BY d.name;

```
> Napisz funkcję, która wyliczy dodatek funkcyjny dla kierowników zespołów. Dodatek funkcyjny powinien wynosić 10% pensji za każdego podległego pracownika, ale nie może przekraczać 50% miesięcznej pensji.
```sql
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
```
## Procedury
> Napisz procedurę, która wykona zmianę stanowiska pracownika. Procedura powinna przyjmować identyfikator pracownika oraz identyfikator jego nowego stanowiska.
```sql
create or replace procedure change_employee_department(e_id number, p_id number)
as
begin
    update employees set position_id = p_id where employee_id = e_id;
end;
```
> Sprawdź działanie procedury wywołując ją z bloku anonimowego.
```sql
BEGIN
    change_employee_department(103, 102);
END;

```
> Napisz procedurę, która zdegraduje zespołowego kierownika o danym identyfikatorze. Na nowego kierownika zespołu powołaj najstarszego z jego dotychczasowych podwładnych.
```sql
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
```
> Sprawdź działanie procedury.
```sql
SELECT * FROM employees WHERE manager_id = 101 OR employee_id = 101;

EXEC change_manager(101);

SELECT * FROM employees WHERE manager_id = 102 OR employee_id = 102;

```
