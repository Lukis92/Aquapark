# Etap 2 — wykonanie (Rails 5.2)

Data wykonania: `2026-06-19`

## Zakres wykonany

### Gemfile
- Podniesiono Rails: `4.2.11.3` -> `5.2.8.1`.
- Zaktualizowano gemy blokujące Rails 5:
  - `coffee-rails ~> 4.1.0` -> `~> 5.0` (railties < 5.2.x był górną granicą w 4.x)
  - `jbuilder ~> 2.0` -> `~> 2.11.5` (2.15+ wymaga Ruby 3.0)
  - `simple_form` (bez wersji, 3.3.1) -> `~> 5.1.0` (3.x wymagało activemodel < 5.1)
  - `mail_form` (1.5.1) -> `~> 1.8.0` (1.5.x blokowało actionmailer < 5)
  - `devise` (4.2.0) -> `~> 4.7` (4.2 blokowało railties < 5.1)
  - `font-awesome-rails` (4.6.x) -> `~> 4.7.0.5` (stare wersje blokowały railties < 5.1)
  - `pg_search` (1.0.6) -> `~> 2.3` (Rails 5 wymaga 2.x API)
  - `web-console ~> 2.0` -> `~> 3.7` (2.x jest Rails 4 only)
  - `mail` -> `~> 2.7.1` (pin: 2.8+ pulls net-imap -> date 3.x native ext, Ruby 3+ only)
- Usunięto gemy niekompatybilne z Rails 5:
  - `where-or` (backport z Rails 5, teraz natywny)
  - `rails-dom-testing 1.0.9` (bundled w Rails 5 jako ~> 2.0)
  - `quiet_assets` (niekompatybilny z Rails 5 asset pipeline)
  - `jquery-smooth-scroll-rails` (railties ~> 4.0, nie istnieje wersja Rails 5)
- Zaktualizowano bundler: `1.17.3` -> `2.1.4` (1.17.3 crashuje przy resolucji Rails 5).

### Kod aplikacji
- Utworzono `app/models/application_record.rb` (Rails 5 convention).
- Zmieniono bazę wszystkich modeli AR: `ActiveRecord::Base` -> `ApplicationRecord` (12 klas; STI subklasy przez `Person`).
- Usunięto `include ActiveModel::Dirty` z `Vacation` (AR już to zawiera, podwójne include powoduje błędy w Rails 5).
- Naprawiono `render nothing: true, status: 404` -> `head :not_found` w `ApplicationController`.

### Konfiguracja
- Usunięto z `config/application.rb`:
  - `config.active_record.raise_in_transactional_callbacks = true` (usunięte w Rails 5)
  - `config.assets.initialize_on_precompile = false` (niepotrzebne w Rails 5)
- Dodano `config.active_record.belongs_to_required_by_default = false` (bezpieczna migracja: niektóre FK są nullable; TODO Stage 3: dodać `optional: true` selektywnie).

### CI (.travis.yml)
- Zaktualizowano bundler do `~> 2.1`.
- Dodano `bundle config` dla natywnych gemów wymagających flagi `-Wno-incompatible-pointer-types` na Windows/GCC: `bcrypt`, `bindex`, `websocket-driver`, `nio4r`.

## Ograniczenia środowiska
- Lokalnie brak PostgreSQL i brak Dockera — `bundle exec rspec` blokuje się na bazie.
- CI (Travis) weryfikuje pełny suite.

## Weryfikacja lokalna
```
bundle exec ruby -e "require './config/boot'; require 'rails/all'; puts 'Rails ' + Rails.version + ' boot OK'"
# => Rails 5.2.8.1 boot OK
```
Brak deprecacji z kodu aplikacji przy `-W`.

## Uwagi
- `devise 4.9.4` (Rails 5.2 + Turbo-compatible) — wygenerowane widoki Devise nie wymagają zmian dla Rails 5.2 bez Hotwire.
- `rolify 5.1.0` — kompatybilne z Rails 5.2.
- `simple_form 5.1.0` — wymaga ponownego uruchomienia `rails generate simple_form:install` po upgrade'ie do Rails 6+ (przy etapie 3/4).
- `pg_search 2.3.6` — API `multisearch` nie zostało zmienione.

## Status Etapu 2
Etap 2 jest **wykonany konfiguracyjnie i kodowo**:
- `Gemfile.lock` przeliczony na Rails `5.2.8.1` / Bundler `2.1.4`,
- aplikacja bootuje bez błędów (`Rails 5.2.8.1 boot OK`),
- brak deprecacji z kodu aplikacji,
- `bundle exec rspec` zablokowane lokalnie brakiem PostgreSQL; CI (Travis) weryfikuje pełny suite.
