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
- `Paperclip` (`app/models/person.rb`) — gem porzucony, wymaga planu migracji (np. ActiveStorage).
- `factory_girl_rails` i `FactoryGirl` w testach — do migracji na `factory_bot`.
- Wiele legacy gemów powiązanych z Rails 4 (`rails_12factor`, `quiet_assets`, stare `web-console`).

## Zmiany przygotowawcze wykonane teraz
- Zamiana `skip_before_filter` -> `skip_before_action`.
- Zamiana `update_attributes` -> `update`.
- Usunięcie `redirect_to :back` w kontrolerach backendu na `safe_redirect_back` (helper w `BackendController`), co jest kompatybilne z nowszym Rails.

## Status Etapu 0
- Etap 0 został wykonany.
- Szczegóły i zasady feature freeze: `docs/stage_0_execution.md`.

## Status Etapu 1
- Etap 1 został rozpoczęty.
- Szczegóły wykonania: `docs/stage_1_execution.md`.

## Kryteria zakończenia
1. Aplikacja działa na Ruby `3.x`.
2. Aplikacja działa na Rails `6.1` lub `7.x`.
3. Testy przechodzą w CI.
4. Brak krytycznych deprecacji w logach.
