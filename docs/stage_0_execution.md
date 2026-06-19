# Etap 0 — wykonanie (stabilizacja)

Data wykonania: `2026-05-08`

## Cel etapu
1. Ustabilizować bazę testów i pipeline.
2. Podnieść Rails do ostatniego patcha linii `4.2`.
3. Wprowadzić zamrożenie zakresu zmian (feature freeze) na czas migracji.

## Co zostało wykonane
- Podniesiono Rails: `4.2.5.1` -> `4.2.11.3` w `Gemfile` i `Gemfile.lock`.
- Uproszczono pipeline Travis (`.travis.yml`):
  - usunięto kruche kroki zależne od konkretnej wersji PostgreSQL (`9.4/9.5`),
  - dodano jawne wymuszenie Bundlera `< 2` (zgodność z Rails 4.2),
  - pozostawiono idempotentne tworzenie bazy testowej.
- Potwierdzono brak lokalnego runtime do uruchomienia testów w tej maszynie (`ruby` i `bundle` niedostępne w PATH).

## Feature freeze (obowiązuje od teraz)
Do zakończenia Etapu 1 i 2:
- nie dodajemy nowych funkcji produktowych,
- dopuszczalne są tylko: poprawki bezpieczeństwa, bugfixy i zmiany migracyjne,
- każda zmiana poza zakresem migracji wymaga osobnej decyzji.

## Następny krok
Etap 1: uruchomienie aplikacji na Ruby `2.7.x` i uporządkowanie gemów blokujących.
