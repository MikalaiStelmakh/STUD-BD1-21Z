# Bazy Danych - Kolokwium 3

> 1. Zaznacz prawidłowe odpowiedzi:
> - [X] a. Funkcje PLSQL mozna wykorzystywać w widokach
> - [X] b. Funkcje zdefiniowane w PLSQL mozna wykorzystywać w procedurach PLSQL
> - [ ] c. Funkcje PLSQL mozemy wywolac poleceniem `EXECUTE`
> - [X] d. Funkcje zdefiniowane w PLSQL można wykorzystać w klauzulach `SELECT`, `HAVING`, `WHERE` i `GROUP BY`

> 2. Zaimplementuj funkcję, która wyliczy `roczny podatek` pracownika. Jeśli pracownik jest zatrudniony w `polskim oddziale` firmy wylicz `podatek progresywny` (stawka 1: `15%`, stawka 2: `25%`, próg: `75000 rocznie`) jeśli w innym to wylicz `podatek liniowy` (stawka `20%`). Zaprezentuj działanie funkcji pisząc zapytanie, które zwróci `średnie roczne podatki w podziale na nazwy departamentów i nazwy stanowisk`.
```sql
create or replace function calculate_year_tax(e_id number)
return number
as
    v_emp_salary number;
    v_tax number;
    v_country_name varchar2(50);
    c_default_tax_coef  constant number:=0.2;
    c_default_tax_coef_pol constant number:=0.15;
    c_increased_tax_coef_pol constant number:=0.25;
    c_limit constant number:= 75000;
    c_country_name constant varchar2(50):='Polska';
begin
    select salary
    into v_emp_salary
    from employees
    where employee_id = e_id;

    select c.name into v_country_name
    from employees e join departments d using(department_id)
    join addresses using(address_id) join countries c using(country_id)
    where e.employee_id = e_id;

    if v_country_name = c_country_name then
        if v_emp_salary*c_default_tax_coef_pol <= c_limit then
            v_tax := v_emp_salary*c_default_tax_coef_pol;
        else
            v_tax := v_emp_salary*c_increased_tax_coef_pol;
        end if;
    else
        v_tax := v_emp_salary*c_default_tax_coef;
    end if;
    return v_tax;
end;
/

select d.name department, p.name position, avg(calculate_year_tax(e.employee_id)) as "avg year tax"
from employees e join departments d using(department_id) join positions p using(position_id)
group by d.name, p.name;
```

> 3. Zaimplementuj procedurę, która dla polskich departamentów zatrudniających więcej niż 8 osób:
> * stworzy nowy departament o nazwie takiej jak "przepełniony" departament z sufiksem 'bis'. (Uzupełnij dane nowego departamentu zgodnie z ustalonymi przez siebie regułami.)
> * połowę pracowników ze starego departamentu przeniesie do nowego.
> * wybierze szefa nowego departamentu (zaproponuj i zaimplementuj sposób wyboru).

> Zaprezentuj sposób działania procedury.
```sql
create or replace procedure emp_modify
as
    cursor cr is select department_id, d.name, count(e.employee_id)
                    from employees e join departments d using(department_id) join addresses a using(address_id)
                    join countries c using(country_id)
                    where c.name = 'Polska'
                    group by department_id, d.name;
    cursor cr_emp is select * from employees;
    v_dep_id number;
    v_dep_name departments.name%type;
    v_num_of_employees number;
    v_employee employees%rowtype;
    v_new_dep_id number:= 200;
    v_new_manager_id number;
    v_emp_counter number;
    c_emp_treshold constant number:=8;
begin
    open cr;
    loop
        exit when cr%notfound;
        fetch cr into v_dep_id, v_dep_name, v_num_of_employees;
        if v_num_of_employees > c_emp_treshold then
            insert into departments values(v_new_dep_id, v_dep_name || 'bis', '01-JAN-21', 300000, NULL, 1001, NULL, '17-NOV-21');
            v_emp_counter := 0;
            open cr_emp;
            loop
                exit when cr_emp%notfound;
                fetch cr_emp into v_employee;
                if (v_employee.department_id = v_dep_id and v_emp_counter < floor(v_num_of_employees/2)) then
                    v_emp_counter := v_emp_counter + 1;
                    update employees set department_id = v_new_dep_id where employee_id = v_employee.employee_id;
                end if;
            end loop;
            close cr_emp;

--          Najstarsza osoba z tego departamentu staje sie szefem
            select employee_id
            into v_new_manager_id
            from employees
            where department_id = v_new_dep_id
            order by extract(year from sysdate) - extract(year from birth_date)
            desc fetch first row only;

            update departments set manager_id = v_new_manager_id where department_id = v_new_dep_id;

            v_new_dep_id := v_new_dep_id + 1;
        end if;
    end loop;
    close cr;
end;
/

exec emp_modify;
```