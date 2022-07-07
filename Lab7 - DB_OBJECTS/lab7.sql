-- Widoki
--1
select * from employees;

create or replace view emp_view as
    select e.name, e.surname, e.salary, d.name, p.name
    from employees e join departments d using(department_id)
    join positions p using(position_id);


--2
create or replace view pos_view as
    select position_id, name, min_salary from positions
    where name like 'P%' or name like 'K%' or name like 'M%'
    WITH CHECK OPTION;


select * from positions;
update pos_view set min_salary = 4000 where position_id=109;

-- Widoki zmaterializowane
--1
create materialized view emp_mview as
    select e.name, e.surname, count(*) from employees e 
    join departments d on(d.manager_id = e.employee_id)
    group by e.name, e.surname;
    
select * from emp_mview;

--2
select * from projects;

create materialized view project_mview as
    select d.department_id, sum(estimated_budget) from projects p
    join departments d on(d.department_id = p.owner)
    group by d.department_id;


drop materialized view project_mview;
--Sekwencje
--2
create sequence int_seq1 start with 100 maxvalue 100 increment by -2 minvalue 0;

select int_seq1.NEXTVAL from dual;

select * from employees;

--Indeksy
--1
create index surname_index on employees(surname);
drop index surname_index;
--2
select * from employees where surname='Janowski';
select * from employees where employee_id = 102;


select * from employees where employee_id>160;

--Indeksy funkcyjne
--1
select * from employees where surname='Himuro';
select * from employees where surname=UPPER('Himuro');