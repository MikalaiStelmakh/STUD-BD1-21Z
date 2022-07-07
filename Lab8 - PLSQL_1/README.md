# Bazy Danych - Laboratorium 8 (PLSQL)
## Blok anonimowy
> Napisz prosty blok anonimowy zawierający blok wykonawczy z instrukcją NULL. Uruchom ten program.
```sql

```
> Zmodyfikuj program powyżej i wykorzystaj procedurę dbms_output.put_line przyjmującą jako parametr łańcuch znakowy do wyświetlenia na konsoli. Uruchom program i odnajdź napis.
```sql

```
> Napisz blok anonimowy który doda do tabeli region nowy rekord (np. ‘Oceania’). Uruchom program i zweryfikuj działanie.
```sql

```
> Napisz blok anonimowy, który wygeneruje błąd (RAISE_APPLICATION_ERROR przyjmującą 2 parametry: kod błędu oraz wiadomość)
```sql

```

> Napisz blok anonimowy który będzie korzystał z dwóch zmiennych (v_min_sal oraz v_emp_id) i który będzie wypisywał na ekran imię i nazwisko pracownika o wskazanym id tylko jeśli  jego zarobki są wyższe niż v_min_sal.
```sql

```

## Funkcje
> Napisz funkcję, która wyliczy roczną wartość podatku pracownika. Zakładamy podatek progresywny. Początkowo stawka to 15%, po przekroczeniu progu 100000 stawka wynosi 25%.
```sql

```
> Stwórz widok łączący departamenty, adresy i kraje. Napisz zapytanie, które pokaże sumę zapłaconych podatków w krajach.
```sql

```
> Napisz funkcję, która wyliczy dodatek funkcyjny dla kierowników zespołów. Dodatek funkcyjny powinien wynosić 10% pensji za każdego podległego pracownika, ale nie może przekraczać 50% miesięcznej pensji.
```sql

```
> Zmodyfikuj funkcję calculate_total_bonus, żeby wyliczała całość dodatku dla pracownika (stażowy i funkcyjny).
```sql

```

## Procedury
> Napisz procedurę, która wykona zmianę stanowiska pracownika. Procedura powinna przyjmować identyfikator pracownika oraz identyfikator jego nowego stanowiska.
```sql

```
> Sprawdź działanie procedury wywołując ją z bloku anonimowego.
```sql

```
> Napisz procedurę, która zdegraduje zespołowego kierownika o danym identyfikatorze. Na nowego kierownika zespołu powołaj najstarszego z jego dotychczasowych podwładnych.
```sql

```
> Sprawdź działanie procedury.
```sql

```
