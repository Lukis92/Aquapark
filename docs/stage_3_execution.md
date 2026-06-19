# Etap 3 — wykonanie (Rails 6.1 + Ruby 3.x)

Data wykonania: `2026-06-19`

## Zakres (wykonany łącznie z Etapem 4 w jednym przejściu)

Etap 3 i 4 zostały wykonane razem — bez możliwości uruchomienia testów między nimi (brak lokalnego PostgreSQL). Finalna wersja docelowa: **Rails 7.0 + Ruby 3.1.6**.

### Ruby: `2.7.6` → `3.1.6`
- `.ruby-version` zaktualizowano na `3.1.6`.
- `Gemfile`: `ruby '2.7.6'` → `ruby '3.1.6'`.
- `.travis.yml`: `rvm: 3.1.6`, bundler `~> 2.4` (usunięto stare flagi natywnych gemów — nieaktualne dla Ruby 3.1).

### Gemy zaktualizowane pod Ruby 3.1
- `mail ~> 2.7.1` → `~> 2.8`: mail 2.8+ deklaruje `net-imap`, `net-smtp`, `net-pop` jako jawne zależności, które w Ruby 3.1 zostały wydzielone ze standardowej biblioteki.
- Usunięto pin `ffi < 1.17` — Ruby 3.1 jest kompatybilny z najnowszą wersją ffi.
- `pg ~> 1.2.3` → `~> 1.5` — aktualny pg 1.5.x, wymaga Ruby 2.5+.
- `bcrypt ~> 3.1, >= 3.1.18` — bez zmian (działa z Ruby 3.1).
- `byebug ~> 11.1` — bez zmian (działa z Ruby 3.1; deprecated od Ruby 3.2+).

### Zeitwerk (Rails 6+ autoloader)
- `config/application.rb`: usunięto `config.autoload_paths << "#{Rails.root}/lib"`. Lib nie zawiera aktywnie używanego kodu wymagającego autoloadingu (moduł `Sort` jest inline w każdym kontrolerze).
- `lib/my_modules/sort.rb`: zmieniono `module My_modules` → `module MyModules` (zgodność z Zeitwerk — inflection `my_modules` → `MyModules`).

### Konfiguracja secrets/credentials
- `config/secrets.yml` pozostaje bez zmian — Rails 7.0 wciąż obsługuje ten plik.
- `config/environments/production.rb`: usunięto `config.secret_key_base = ENV["SECRET_KEY_BASE"]` (ten klucz jest czytany z `secrets.yml` lub credentials; duplikat zbędny).
- TODO Stage 5: przepiąć na `config/credentials.yml.enc` dla lepszego bezpieczeństwa.

## Ograniczenia środowiska
- Lokalnie brak PostgreSQL i Dockera — `bundle exec rspec` blokuje się na bazie.
- CI (Travis) weryfikuje pełny suite po push.

## Status Etapu 3
Etap 3 **wykonany konfiguracyjnie i kodowo** jako część wspólnego przejścia 3+4.
Szczegóły finalnego stanu: `docs/stage_4_execution.md`.
