# Bazy Danych - Laboratorium 7 (OBJECTS)
## Views
> Zdefiniuj widok, który będzie zwracać imię, nazwisko, zarobki, nazwę
stanowiska, nazwę departamentu oraz imię i nazwisko managera dla
wszystkich pracowników w tabeli employees.
```sql

```
>Zdefiniuj widok typu WITH CHECK OPTION przechowujący id stanowisk
(position_id) oraz nazwę, minimalne zarobki wszystkich stanowisk
rozpoczynających się od litery ‘P’, ‘K’ lub ‘M’. Następnie spróbuj zwiększyć
minimalne zarobki dla stanowiska ‘Rekruter’ o 1000 i przeanalizuj komunikat
błędu.
```sql

```
> Wykonaj polecenia DROP VIEW, aby usunąć jeden z wcześniej utworzonych
widoków.
```sql

```

## Materialized Views
> Zdefiniuj widok, zmaterializowany, który będzie przechowywał imię i nazwisko
kierowników i liczbę jego podwładnych.
```sql

```
> Zdefiniuj widok zmaterializowany przechowujący informacje o sumie
budżetów (estimated_budget) projektów prowadzonych przez dany
departament.
```sql

```
> Do widoku stworzonego w powyzszym poleceniu dodaj kolumnę z informacją
o procentowym udziale sumy budzetow projektow w rocznym budzecie
danego departamentu. Zaokrąglij procentowy udzial do 2 miejsc po
przecinku. Posortuj malejąco względem tego procentowego udziału.
```sql

```
> Wykonaj polecenia DROP MATERIALIZED VIEW, aby usunąć jeden z
wcześniej utworzonych widoków.
```sql

```

## Sequences, synonyms
> Zdefiniuj sekwencję, która: (i) będzie posiadała minimalną wartość 10; (ii)
rozpocznie generowanie wartości od 12; (iii) będzie posiadała maksymalną
wartość 17; (iv) będzie cykliczna. Następnie wygeneruj kilkanaście wartości
za pomocą tej sekwencji i obserwuj rezultaty.
```sql

```
> Zdefiniuj sekwencję, która będzie generowała malejąco liczby parzyste
z przedziału 100 ÷ 0.
```sql

```
> Nadaj synonim dla dowolnej z dwóch poprzednio zdefiniowanych sekwencji
i pobierz z niej wartość za pomocą synonimu.
```sql

```