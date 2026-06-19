# Etap 1 — wykonanie (Ruby 2.7)

Data aktualizacji: `2026-06-10`

## Zakres wykonany
- Ustawiono docelowe Ruby `2.7.6`:
  - `Gemfile` (`ruby '2.7.6'`)
  - `.ruby-version`
  - `.travis.yml` (`rvm: 2.7.6`)
- Zaktualizowano kluczowe gemy pod Ruby 2.7 (bez zmiany głównej wersji Rails):
  - `pg` -> `~> 1.2.3`
  - `bcrypt` -> `~> 3.1, >= 3.1.18`
  - `byebug` -> `~> 11.1`
  - `capybara` -> `~> 3.39, < 3.40`
  - `rspec-rails` -> `~> 4.0, >= 4.0.2`
  - `factory_girl_rails` -> `factory_bot_rails ~> 5.2, >= 5.2.0`
  - `ffi` -> `< 1.17` (kompatybilność Windows/Ruby 2.7)
  - `tzinfo-data` dla platform Windows
  - usunięto `rb-readline`
- Wykonano migrację testów `FactoryGirl` -> `FactoryBot`:
  - zmiana DSL we wszystkich factory/specach,
  - zmiana statycznych atrybutów factory na składnię blokową FactoryBot 5,
  - aktualizacja generatora (`factory_girl` -> `factory_bot`),
  - przeniesienie `spec/support/factory_girl.rb` -> `spec/support/factory_bot.rb`.
- Dodano shim kompatybilnościowy dla Rails 4.2 na Ruby 2.7:
  - przywrócenie `BigDecimal.new` jako delegacji do `BigDecimal(...)`,
  - obejście starego sprawdzenia adaptera Rails 4.2 `gem 'pg', '~> 0.15'`,
  - aliasy `PGconn`, `PGresult`, `PGError` dla `pg 1.x`.
- Poprawiono puste controller specy backendu tak, aby ładowały `rails_helper`.

## Ograniczenie środowiska (ważne)
W tym środowisku `ruby 2.7.6` i `bundle 1.17.3` są dostępne i wykorzystane do przeliczenia `Gemfile.lock`.

Lokalny blocker testów:
- brak `psql` w `PATH`,
- brak działającej usługi PostgreSQL,
- `localhost:5432` odrzuca połączenia.

Z tego powodu `bundle exec rspec` dochodzi do inicjalizacji testowej bazy i kończy się błędem `PG::ConnectionBad`.

Uwaga dla Windows: lokalna kompilacja `bcrypt 3.1.22` wymagała ustawienia:

```powershell
bundle _1.17.3_ config build.bcrypt --with-cflags=-Wno-incompatible-pointer-types
```

## Co trzeba zrobić od razu po stronie runtime
Po uruchomieniu środowiska z Ruby 2.7.6:
1. `bundle _1.17.3_ install`
2. uruchomić PostgreSQL lokalnie albo w CI
3. `cp config/database.yml.sample config/database.yml`
4. `psql -U postgres -c 'CREATE DATABASE aquapark_test;'` (jeśli baza nie istnieje)
5. `bundle exec rspec`

## Status Etapu 1
Etap 1 jest **wykonany konfiguracyjnie i kodowo**:
- `Gemfile.lock` został przeliczony na Ruby `2.7.6` / Bundler `1.17.3`,
- aplikacja przechodzi kolejne blokery startowe Ruby 2.7,
- `bundle check` jest zielone,
- `bundle exec rspec` jest zablokowane lokalnie wyłącznie przez brak działającego PostgreSQL.
