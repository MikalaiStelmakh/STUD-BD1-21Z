# Bazy Danych - Kolokwium 4

> 1. Stwórz sekwencję, która będzie zwracała liczbę całkowitą malejącą startując od numeru 99, a po osiągnięciu liczby 27, zacznie ponownie zwracać liczby poczynając od 99.
```sql
CREATE SEQUENCE seq increment by -1 start with 99 maxvalue 99 minvalue 27 cycle;
```

> 2. Napisz widok, który będzie zwracał rok założenia, nazwę oraz średni roczny budżet departamentów dla grup tworzonych ze względu na rok założenia departamentu.
```sql
create or replace view dep_view as
    select established, name, (select avg(year_budget) from departments
                               where department_id = d.department_id
                               group by established) avg_budget
    from departments d;
```

> 3. Stwórz widok zmaterializowany, który będzie przechowywał konkatenację imienia i nazwiska (ze spacją) pracownika, nazwę zakładu w którym pracuje, nazwę kraju w którym jest zakład przy ograniczeniu ze zakłady mają mieć swoje siedziby w krajach, w których liczba ludności jest wyższa niż 40 (mln). Napisz zapytanie prezentujące wykorzystanie widoku.
```sql
create materialized view dep_emp_mview as
    select e.name || ' ' || e.surname "Name", d.name "Department", c.name "Country" from employees e
    join departments d using(department_id) join addresses a using(address_id)
    join countries c using(country_id)
    where department_id in (
                        select department_id from departments join addresses a using(address_id)
                        join countries c using(country_id)
                        where country_id in (select country_id from countries where population > 40));
select * from dep_emp_mview;
```

> 4. Zaznacz prawidłowe odpowiedzi dotyczące indeksów typu B-drzewo:
> - [X] a. przechowują wartości kolumn indeksujących w sposób posortowany
> - [ ] b. wartości w kolumnach indeksowanych muszą być unikalne.
> - [X] c. mogą być stworzone na jednej kolumnie lub na większej liczbie kolumn
> - [ ] d. mogą być założone jedynie na kolumnach liczbowych