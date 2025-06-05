# Aquapark
> Aplikacja wspomagająca pracę aquaparku.

[![Build Status][travis-image]][travis-url]

## Struktura aplikacji
Aplikacja ma za zadanie wspierać wszelkie aspekty związane z klientami kompleksu
wodnego jak i pracownikami. Wyróżniamy 4 rodzaje zatrudnionych osób: kierownicy,
recepcjoniści, trenerzy, ratownicy.

![](header.png)

## Główne funkcje

Możliwości po stronie klienta:
* kupno biletu/karnetu
* zakup treningu indywidualnego z trenerem
* rezerwacja udziału w zajęciach grupowych

Możliwości po stronie pracowników(wszyscy):
* wysłanie prośby o urlop
* sprawdzenie harmonogramu pracy
* zaproponowanie zajęć grupowych

Możliwości po stronie recepcjonisty:
* Edycja danych osobowych klienta
* Pisanie newsów na stronie z aktualnościami
* Zarządzanie wejściówkami
* Dodanie zajęcia grupowego

Możliwości po stronie trenera:
* Sprawdzenie harmonogramu treningów z klientami oraz zajęć grupowych
* Zaproponowanie zajęć

Możliwości po stronie kierownika:
* Rejestracja pracownika(w raz z utworzeniem konta w systemie)
* Wyświetlenie statystyk dotyczących funkcjonowania aquaparku(m.in bilans zyskóœ i strat)

## Instalacja
 Sklonuj repozytorium i zainstaluj wymagane gemy:
 ```
 $ bundle install --without production
 ```
 Następnie skopiuj database.yml.sample i zmień nazwę tego drugiego na database.yml.
 Skonfiguruj nowy plik z twoim lokalnym kontem PostgreSQL.

Następnie, utwórz bazę:

```
$ rails db:create
```

Następnie, zmigruj bazę:

```
$ rails db:migrate
```

Następnie, wygeneruj konto użytkownika:

```
$ rails db:manager
```

Finalnie, możesz odpalić serwer i zobaczyć rezultat

```
$ rails s
```

## Historia zmian
* 0.5.4
  * Naprawiono wyszukiwanie nakładających się aktywności oraz tłumaczenie dni (I18n)
  * Dodano komentarze dokumentacyjne
  * Poprawiono literówkę w changelogu
  * Naprawiono walidację wolnego czasu klienta i dodano testy jednostkowe
  * Dodano testy walidacji obecności dla BoughtDetail
  * Zaktualizowano komentarz dotyczący czyszczenia bazy danych
  * Zrefaktoryzowano kontroler home i scope’y typu wpisu
  * Dodano brakujące testy jednostkowe

* 0.5.3
  * Zabezpieczenie przed niepowołanym wejściem w sekcję urlopów
  * Poprawienie walidacji nachodzenia na siebie urlopów
  * Usunięty błąd z akceptowaniem urlopu przez kierownika
  * naprawione statystyki dot. newsów
  * umożliwienie recepcjonistom zarządzaniem komentarzami
  * zablokowanie możliwości edycji urlopów pracownikom poza niezatwierdzonymi
  * widoczność własnych newsów mimo należności do innej kategorii
  * podczas dodawania zajęcia grupowego, sprawdzane jest czy trener ma w tym czasie inne zajęcia lub treningi
  * podczas dołączania klienta do zajęć, sprawdzane jest czy klient ma w tym czasie inne zajęcia lub treningi
  * naprawione przyciski wróć w wynikach wyszukiwania
* 0.5.2
  * Naprawienie żle wyświetlających się podstron
  * Dodanie notatek informacyjnych na każdej podstronie
  * Wyświetlanie tylko najbliższych terminów zajęć grupowych
  * Usunięty zielony haczyk przy pustych opisach cen biletów/karnetów
  * Wyrównane wysokości bloków z cenami
  * Poprawienie wyglądu komentarza
  * Sortowane kolumny w activities/requests
  * Usunięte sortowania z rezultatów wyszukiwań
  * Dodanie napisu informującego, że dany atrybut nie ma przypisanej wartości
  * Naprawienie wyszukiwania po dacie rekordów
  * Dodanie ilości likeów na stronie newsa
  * naprawienie edycji treningu indywidualnego

## Autor
Łukasz Korol - lukas.korol@gmail.com
Licencja - Użytek wyłącznie w celach naukowych.
[https://github.com/Lukis92](https://github.com/Lukis92)

[travis-image]: https://travis-ci.org/Lukis92/Aquapark.svg?branch=master
[travis-url]: https://travis-ci.org/Lukis92/Aquapark
