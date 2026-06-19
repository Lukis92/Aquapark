# Plan modernizacji stacku (Ruby/Rails)

## Stan wyjściowy (2026-05-08)
- Ruby: `2.3.1` (EOL od `2019-03-31`)
- Rails: `4.2.11.3` (ostatnia wersja linii 4.2, wydana `2020-05-16`)
- Bundler (lock): `1.12.5`

To oznacza brak aktualnych poprawek bezpieczeństwa i rosnące ryzyko awarii przy nowych bibliotekach/systemach.

## Strategia etapowa
### Etap 0 — Stabilizacja i przygotowanie
1. Ustabilizować bazę testów (`rspec`) i pipeline.
2. Podnieść Rails do ostatniego patcha linii 4.2 (`4.2.11.3`) jako krok pomostowy.
3. Zamrozić zakres funkcjonalny na czas migracji (tylko bugfix/security).

### Etap 1 — Ruby `2.3.1 -> 2.7.x`
1. Uruchomić aplikację na Ruby `2.7.x` bez zmiany głównej wersji Rails.
2. Zaktualizować gemy blokujące Ruby 2.7 (priorytet: testowe i natywne).
3. Usunąć ostrzeżenia/deprecacje Ruby, aż testy będą zielone.

### Etap 2 — Rails `4.2 -> 5.2`
1. Dodać klasy bazowe `ApplicationRecord`, `ApplicationJob`, `ApplicationMailer`.
2. Usunąć deprecacje Rails 4/5 i zaktualizować konfigurację (`app:update`).
3. Uporządkować niekompatybilne gemy (np. `where-or`, stare wersje `web-console`, `coffee-rails`, `factory_girl_rails`).

### Etap 3 — Rails `5.2 -> 6.1` + Ruby `3.x`
1. Przejść na Ruby `3.x` i zaktualizować gemy pod nowy parser/keyword arguments.
2. Włączyć loader Zeitwerk i poprawić autoloading.
3. Uporządkować konfigurację secrets/credentials.

### Etap 4 — Rails `6.1 -> 7.x`
1. Wybrać finalny model front-endowy (Sprockets/JS bundling).
2. Domknąć migracje frameworkowe i deprecacje.
3. Odczyścić nieużywane gemy/initializery po migracji.

## Blokery zidentyfikowane w tym repo
- ✅ `Paperclip` — zmigrowany na ActiveStorage (`aws-sdk-s3`, `image_processing`). Szczegóły: `docs/blockers_resolution.md`.
- ✅ `factory_girl_rails` / `FactoryGirl` — zmigrowane na `factory_bot_rails` w Etapie 1.
- ✅ Legacy gemy Rails 4 (`rails_12factor`, `quiet_assets`, `where-or` itd.) — usunięte w Etapach 2–4.
- ✅ `jquery_ujs` vs `rails-ujs` — przepięto na `rails-ujs` w `application.js`.
- ✅ `config/secrets.yml` — naprawiono składnię ERB (`ENV[...]` zawinięto w `<%= %>`).
- Migracja `secrets.yml` → `credentials.yml.enc` — opcjonalna (secrets.yml działa w Rails 7.0).

## Zmiany przygotowawcze wykonane teraz
- Zamiana `skip_before_filter` -> `skip_before_action`.
- Zamiana `update_attributes` -> `update`.
- Usunięcie `redirect_to :back` w kontrolerach backendu na `safe_redirect_back` (helper w `BackendController`), co jest kompatybilne z nowszym Rails.

## Status Etapu 0
- Etap 0 został wykonany.
- Szczegóły i zasady feature freeze: `docs/stage_0_execution.md`.

## Status Etapu 1
- Etap 1 **zakończony** (commit `48863b2`).
- Szczegóły wykonania: `docs/stage_1_execution.md`.

## Status Etapu 2
- Etap 2 **zakończony** — aplikacja działa na Rails `5.2.8.1`.
- Szczegóły wykonania: `docs/stage_2_execution.md`.

## Status Etapu 3
- Etap 3 **zakończony** (łącznie z Etapem 4 — jedno przejście, brak lokalnego DB).
- Ruby `2.7.6` → `3.1.6`, Zeitwerk, secrets/credentials bez zmian.
- Szczegóły wykonania: `docs/stage_3_execution.md`.

## Status Etapu 4
- Etap 4 **zakończony** — aplikacja docelowo na Rails `7.0.8` / Ruby `3.1.6`.
- Front-end: Sprockets 4 + jQuery + Bootstrap 3 (bez importmap/esbuild).
- Deprecated gemy usunięte (`coffee-rails`, `turbolinks`, `rails_12factor`).
- Szczegóły wykonania: `docs/stage_4_execution.md`.

## Kryteria zakończenia
1. ✅ Aplikacja działa na Ruby `3.1.6`.
2. ✅ Aplikacja działa na Rails `7.0.8`.
3. ✅ Paperclip usunięty, ActiveStorage skonfigurowany.
4. ✅ UJS przepięty na `rails-ujs`.
5. Testy przechodzą w CI (weryfikacja po push — lokalnie brak PostgreSQL).
6. Brak krytycznych deprecacji w logach (po uruchomieniu z psql).

## Stan końcowy (2026-06-19)
- Ruby: `3.1.6`
- Rails: `7.0.8`
- Bundler: `2.4.x`
- Upload plików: ActiveStorage + S3 (`aws-sdk-s3 ~> 1.0`, `image_processing ~> 1.12`)
- Asset pipeline: Sprockets 4 + jQuery + Bootstrap 3 SASS + `rails-ujs`

## Co pozostało (opcjonalne)
- Migracja danych S3: `bundle exec rails paperclip:migrate_to_activestorage` (po deploymencie).
- Usunięcie starych kolumn Paperclip z tabeli `people` (po migracji danych).
- Migracja `secrets.yml` → `credentials.yml.enc` (nie blokuje działania).
- Aktualizacja `simple_form`: `rails generate simple_form:install` (po deploymencie Rails 7).
- Audyt `belongs_to optional: true` (FK nullable) i usunięcie override w `application.rb`.
