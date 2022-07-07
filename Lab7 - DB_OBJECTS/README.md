# Bazy Danych - Laboratorium 7 (OBJECTS)
## Views
> Zdefiniuj widok, który będzie zwracać imię, nazwisko, zarobki, nazwę
stanowiska, nazwę departamentu oraz imię i nazwisko managera dla
wszystkich pracowników w tabeli employees.
```sql
CREATE OR replace view emp_view AS
    SELECT e.name, e.surname, e.salary, d.name, p.name, m.name, m.surname
    FROM employees e JOIN departments d USING(department_id)
    JOIN positions p USING(position_id)
    JOIN employees m ON(e.manager_id = m.employee_id);
```
>Zdefiniuj widok typu WITH CHECK OPTION przechowujący id stanowisk
(position_id) oraz nazwę, minimalne zarobki wszystkich stanowisk
rozpoczynających się od litery ‘P’, ‘K’ lub ‘M’. Następnie spróbuj zwiększyć
minimalne zarobki dla stanowiska ‘Rekruter’ o 1000 i przeanalizuj komunikat
błędu.
```sql
CREATE OR REPLACE VIEW pos_view AS
    SELECT position_id, name, min_salary FROM positions
    WHERE name LIKE 'P%' OR name LIKE 'K%' OR name LIKE 'M%'
    WITH CHECK OPTION;

UPDATE pos_view SET min_salary = 4000 WHERE position_id=109;
```
> Wykonaj polecenia DROP VIEW, aby usunąć jeden z wcześniej utworzonych
widoków.
```sql
DROP VIEW pos_view;
```

## Materialized Views
> Zdefiniuj widok, zmaterializowany, który będzie przechowywał imię i nazwisko
kierowników i liczbę jego podwładnych.
```sql
CREATE MATERIALIZED VIEW emp_mview AS
    SELECT m.name, m.surname, COUNT(*)
    FROM employees e
    JOIN employees m on(e.manager_id = m.employee_id)
    GROUP BY m.employee_id, m.name, m.surname;
```
> Zdefiniuj widok zmaterializowany przechowujący informacje o sumie
budżetów (estimated_budget) projektów prowadzonych przez dany
departament.
```sql
CREATE materialized view project_mview AS
    SELECT d.department_id, SUM(estimated_budget) FROM projects p
    JOIN departments d ON(d.department_id = p.owner)
    GROUP BY d.department_id;
```
## Sequences, synonyms
> Zdefiniuj sekwencję, która:
> - będzie posiadała minimalną wartość 10;
> - rozpocznie generowanie wartości od 12;
> - będzie posiadała maksymalną wartość 17;
> - będzie cykliczna. Następnie wygeneruj kilkanaście wartości za pomocą tej sekwencji i obserwuj rezultaty.
```sql
create sequence int_seq1
    start with 12
    minvalue 10
    maxvalue 17
    cycle;

SELECT int_seq1.NEXTVAL FROM dual;
```
> Zdefiniuj sekwencję, która będzie generowała malejąco liczby parzyste
z przedziału 100 ÷ 0.
```sql
create sequence int_seq1 start with 100 maxvalue 100 increment by -2 minvalue 0;
```
> Nadaj synonim dla dowolnej z dwóch poprzednio zdefiniowanych sekwencji
i pobierz z niej wartość za pomocą synonimu.
```sql
CREATE SYNONYM int_seq2 FOR int_seq1;

SELECT int_seq1.NEXTVAL FROM DUAL;
SELECT int_seq2.NEXTVAL FROM DUAL;
```