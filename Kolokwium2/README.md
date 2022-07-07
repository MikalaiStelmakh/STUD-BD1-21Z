# Bazy Danych - Kolokwium 2

> 1. Żeby skorzystać ze złączenia pionowego i dokonać operacji sumy (UNION) na wynikach dwóch zapytań konieczne jest:
> - [ ] a. Zwrócenie w wynikach kluczy głównych i obcych, po których można połączyć te wyniki.
> - [X] b. Liczba kolumn w podzapytaniach musi być zgodna.
> - [ ] c. Liczba wierszy w podzapytaniach musi być zgodna.
> - [ ] d. Nazwy kolumn zwracanych przez zapytania muszą być identyczne

> 2. Złączenie naturalne ...
> - [ ] a. ma w wynikach po jednej kolumnie złączeniowej
> - [X] b. jest szczególnym rodzajem złączenia równościowego.
> - [ ] c. może być zarówno równościowe jak i nierównościowe
> - [ ] d. jest iloczynem kartezjańskim ponieważ nie przyjmuje warunku złączenia
> - [X] e. może zwrócić iloczyn kartezjański

> 3. Wykonaj polecenie:
```sql
INSERT INTO addresses VALUES (1021, 'Czechowa', '87-967', 'KIELCE', 104);
```

>Napisz zapytanie zwracające wszystkie nazwy miast wraz z informacją o liczbie istniejących w nich zakładów oraz średnim budżetem. Upewnij się, że w wynikach są wszystkie miasta, także takie w których nie ma żadnych zakładów. Jeśli średni zakładowy budżet w mieście jest pusty w wynikach umieść wartość 0.
```sql
select a.city, count(d.department_id), nvl(avg(d.year_budget), 0) from addresses a left outer join departments d using(address_id)
group by a.city;
```

> 4. Napisz jedno zapytanie które zwróci nazwę departamentu i liczbę jego pracowników wraz z informacją o sumie ich pensji oraz różnicy między budżetem departamentu a sumą pensji pracowników oraz nazwę stanowiska i liczbę pracowników pracujących na tym stanowisku wraz z informacją o sumie ich pensji oraz różnicą między max_pensja na stanowisku wymnożoną przez liczbę pracowników (na tym stanowisku) a sumą pensji pracowników (na tym stanowisku). W wynikach wyświetl kategorię wpisu 'D' dla departamentu i 'P' dla stanowisk.
```sql
select 'D' kategoria, d.name nazwa, count(e1.employee_id) liczba, sum(e1.salary) suma_pensji, d.year_budget-sum(e1.salary) roznica from departments d left outer join employees e1 using(department_id)
group by d.name, d.year_budget
union
select 'P', p.name, count(e2.employee_id), sum(e2.salary), p.max_salary*count(e2.employee_id)-sum(e2.salary) from positions p left outer join employees e2 using(position_id)
group by p.name, p.max_salary;
```

> 5. Napisz zapytanie zwracające informacje o pracownikach, których kierownikiem jest Irene Janowski. W wynikach podaj: imię i nazwisko  pracownika, jego nazwę zakładu oraz imię i nazwisko kierownika.
```sql
select e1.name, e1.surname, d.name nazwa_departamentu, e2.name imie_kierownika, e2.surname nazwisko_kierownika
from employees e1 join departments d using(department_id) join employees e2 on(e1.manager_id = e2.employee_id)
where e2.name = 'Irene' and e2.surname = 'Janowski';
```

> 6. Dla pracowników kobiet aktualnie zatrudnionych w projektach przygotuj zestawienie: id, imie i nazwisko pracownika, id projektu, nazwa projektu oraz nazwa statusu tego projektu.
```sql
select employee_id, e.name, e.surname, project_id, p.name, ps.name
from employees e join emp_projects ep using(employee_id) join projects p using(project_id)
join project_status ps on (p.status = ps.ps_id)
where ep.date_end IS NULL;
```

> 7. Napisz zapytanie, które zwróci średnie minimalne zarobki pogrupowane ze względu na pierwszą literę nazw stanowisk.
```sql
select substr(name, 1, 1) pierwsza_litera, avg(min_salary) from positions
group by substr(name, 1, 1);
```

> 8. Wykorzystując podzapytania napisz zapytanie zwracające nazwę miasta, w którym pracuje najpóźniej zatrudniona kobieta.
```sql
select a.city from addresses a
where address_id = (
    select d.address_id from employees e join departments d using(department_id)
    where e.date_employed = (select min(date_employed) from employees where gender='K')
);
```