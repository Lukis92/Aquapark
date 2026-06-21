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

## Plan modernizacji stacku
Szczegółowy plan etapowej modernizacji Ruby/Rails znajduje się w:
`docs/stack_modernization_plan.md`.
Raport wykonania Etapu 0 (stabilizacja + feature freeze):
`docs/stage_0_execution.md`.
Raport realizacji Etapu 1 (Ruby 2.7):
`docs/stage_1_execution.md`.

## Wymagania

- **Ruby 3.4.9** — zalecana instalacja przez [RubyInstaller](https://rubyinstaller.org/downloads/) (Windows) lub rbenv/RVM (Linux/macOS)
- **PostgreSQL** (lokalnie, np. przez [EDB installer](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads))
- **Bundler** (`gem install bundler`)

## Instalacja i uruchomienie lokalne

### 1. Sklonuj repozytorium

```bash
git clone <url-repozytorium>
cd Aquapark
```

### 2. Zainstaluj gemy

```bash
bundle install
```

### 3. Skonfiguruj bazę danych

Plik `config/database.yml` jest już gotowy do użycia lokalnego (adapter: PostgreSQL, host: localhost, user: postgres). Jeśli Twój PostgreSQL ma hasło, uzupełnij pole `password:`:

```yaml
# config/database.yml
connection: &connection
  adapter: postgresql
  username: postgres
  password: TWOJE_HASŁO   # uzupełnij jeśli wymagane
  host: localhost
```

### 4. Utwórz i zmigruj bazę danych

```bash
rails db:create
rails db:migrate
```

### 5. Utwórz konto managera

```bash
rails db:seed:manager
```

### 6. Uruchom serwer

```bash
rails s
```

Aplikacja będzie dostępna pod adresem **http://localhost:3000**.

### Dane do logowania managera

Dane logowania managera znajdziesz w pliku `db/seeds/manager.rb`.

## Historia zmian
* 0.6.2 *(2026-06-21)*
  * **Filtry na wszystkich stronach backendowych**
    * Spójny panel filtrów (Bootstrap grid, bez konfliktu z MDB) zastąpił rozbite searchbary na: `/backend/people`, `/backend/activities`, `/backend/entry_types`, `/backend/manage_vacations`, `/backend/news`, `/backend/individual_trainings`
    * Usunięto zduplikowane searchbary i navbar zakładek typów — jeden panel filtrów na stronę
    * Filtry: imię/nazwisko/PESEL/typ (osoby), nazwa/status/dzień/strefa/trener (zajęcia), klient/trener/data (treningi), pracownik/data/status (urlopy), rodzaj/szczegóły (wejściówki), tytuł (newsy)
  * **PESEL — rejestracja klientów**
    * Pole PESEL usunięte z formularza rejestracji klienta (`/clients/sign_up`) — klienci nie muszą go podawać
    * Migracja: kolumna `pesel` nullable dla klientów; walidacja pomijana dla typu `Client`
  * **PESEL — rejestracja pracowników** (`/backend/people/sign_up`)
    * Walidacja sumy kontrolnej (wagi `1,3,7,9,1,3,7,9,1,3`) zamiast samego sprawdzenia długości
    * Pole „Data urodzenia" usunięte z formularza — auto-uzupełniane z PESEL po wpisaniu 11 cyfr (JS + `before_validation` w modelu, obsługa stuleci 1800–2299)
  * **Strona statystyk** (`/backend/statistics`) — pełny redesign
    * Stat-karty z ikonami Font Awesome, gradientowymi tłami, 4 kolorowe sekcje: Osoby / Finanse / Zatrudnienie / Newsy
    * Bilans zysk/strata dynamicznie zmienia kolor (zielony/czerwony)
    * Nowe wskaźniki: urlopy aktywne dziś, bilety sprzedane dziś
  * **Kompaktowe przyciski akcji w tabelkach** — globalny CSS (`btn-xs` equivalent) bez zmian w widokach
  * **Dane testowe** (`db/seeds/bought_history.rb`) — 200 rekordów historii zakupów biletów i karnetów dla klientów z ostatnich 18 miesięcy; tworzy domyślne typy wejściówek jeśli brak
  * **Fix: manager może edytować każdy urlop** — poprzednio blokowany przez status akceptacji lub datę w przeszłości

* 0.6.1 *(2026-06-21)*
  * **Grafik pracy — widok kalendarza** (`/backend/work_schedules`)
    * Zastąpiono tabelę dzienną siatką tygodniową: wiersze = pracownicy, kolumny = dni tygodnia (Pn–Nd)
    * Paginacja 20 pracowników na stronę
    * Filtr po konkretnym pracowniku (dropdown)
    * Filtr po typie pracownika: Recepcjonista / Ratownik / Trener / Kierownik
    * W każdej komórce siatki widoczne godziny pracy oraz przyciski edycji/usunięcia (dla managera)
  * **Masowe dodawanie grafiku** (`/backend/work_schedules/new`)
    * Wielokrotny wybór dni tygodnia (checkboxy z przyciskami „zaznacz wszystkie / odznacz wszystkie")
    * Lista pracowników pogrupowana po typie z zakładkami filtrowania (bez przeładowania strony)
    * Przyciski „zaznacz grupę" / „zaznacz widocznych" / „odznacz wszystkich"
    * Kontroler tworzy po jednym `WorkSchedule` dla każdej kombinacji dzień × pracownik; już istniejące grafiki są pomijane z komunikatem
  * **Dane testowe** (`db/seeds/bulk_data.rb`)
    * Seed dodający 100 klientów, 15 recepcjonistów, 25 ratowników, 60 trenerów
    * Automatyczne tworzenie grafiów pracy, zajęć grupowych, treningów indywidualnych, zapisów na zajęcia i urlopów
    * Uruchomienie: `rails runner db/seeds/bulk_data.rb`
  * **Fix: manager może edytować każdy urlop** (`VacationsController#edit_rule_vacations`)
    * Poprzednia logika blokowała managera gdy urlop był już zaakceptowany lub miał datę w przeszłości
    * Manager ma teraz pełny dostęp do edycji; ograniczenia (niezaakceptowany + przyszła data) dotyczą wyłącznie pracowników edytujących własne urlopy

* 0.6 *(2026-06-19)*
  * **Ruby 3.1.7 → 3.4.9** — instalacja przez winget (`RubyInstallerTeam.RubyWithDevKit.3.4`)
  * **Rails 7.0.10 → 8.1.3** — aktualizacja wszystkich zależności Rails
  * **Puma 5.x → 6.6.1** — aktualizacja serwera aplikacji
  * Zastąpiono `sass-rails` przez `sassc-rails` (LibSass przez Sprockets, kompatybilne z Rails 8)
  * Dodano `sprockets-rails` jawnie do Gemfile (Rails 8 nie dodaje go domyślnie)
  * Usunięto gem `uglifier` (niezgodny z Rails 8; kompresja JS nie jest wymagana w dev)
  * `config.load_defaults` zaktualizowane z `7.0` na `8.1`
  * `config.cache_classes` zastąpione przez `config.enable_reloading` we wszystkich środowiskach
  * `config.assets.js_compressor = :uglifier` usunięte z `production.rb`
  * `config.active_support.deprecation` zastąpione przez `config.active_support.report_deprecations`
  * `config.action_dispatch.show_exceptions = false` → `:none` w `test.rb`
  * Naprawiono błąd tras: `:search` i `:choose_trainer` usunięte z parametru `only:` w `routes.rb` (błąd `ArgumentError` w Rails 8)
  * `i18n` odblokowane z wersji `< 1.15` — brak ograniczenia górnego
  * Zainicjalizowano zestaw kluczy GPG MSYS2 i zainstalowano `libyaml` dla gemu `psych`

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
