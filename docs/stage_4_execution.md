# Etap 4 — wykonanie (Rails 7.0)

Data wykonania: `2026-06-19`

## Zakres

Etap 4 przeszedł bezpośrednio na **Rails 7.0.8** (łącznie z Etapem 3 w jednym przejściu).

### Rails: `5.2.8.1` → `7.0.8`
- `Gemfile`: `gem 'rails', '~> 7.0.8', '>= 7.0.8.6'`

### config/application.rb
- `config.load_defaults 7.0` — włączono wszystkie domyślne Rails 7.0.
- Usunięto `require File.expand_path('../boot', __FILE__)` → `require_relative 'boot'` (nowoczesna składnia).
- Usunięto `config.autoload_paths << "#{Rails.root}/lib"` — Zeitwerk nie wymaga tej ścieżki dla martwego kodu w `lib/`.
- Zachowano `config.active_record.belongs_to_required_by_default = false` jako nadpisanie domyślnego `true` (TODO: audyt FK nullable → dodać `optional: true`).

### Wybór modelu front-end (Etap 4 pkt 1)
Zachowano **Sprockets 4 + jQuery + Bootstrap 3** (brak przejścia na importmap / esbuild):
- Aplikacja używa jQuery, jQuery UI, Bootstrap 3 SASS, turbolinks-like behavior — przejście na importmap wymagałoby przepisania całego frontend.
- `gem 'sprockets', '~> 4.0'` — aktualny Sprockets 4.
- `gem 'sass-rails', '~> 6.0'` — Rails 6+ sass-rails.
- `gem 'uglifier', '>= 4.0.0'` — kompresja JS przez ExecJS (Heroku ma Node.js).
- `config.assets.js_compressor = :uglifier` w production.rb.

### Usunięte gemy (Etap 4 pkt 3 — czyszczenie)
| Gem | Powód |
|-----|-------|
| `coffee-rails` | Brak plików `.coffee` w projekcie; CoffeeScript martwy w Rails 6+ |
| `turbolinks` | Nie wymagany w `application.js`; Rails 7 używa Turbo |
| `jquery-turbolinks` | Zależny od `turbolinks` |
| `rails_12factor` | Heroku Buildpack v5+ ustawia te zmienne automatycznie |
| `ffi < 1.17` (pin) | Zbędny dla Ruby 3.1 — bundler dobiera aktualną wersję |

### Zaktualizowane gemy
| Gem | Ze | Na | Powód |
|-----|----|----|-------|
| `devise` | `~> 4.7` | `~> 4.9` | Rails 7 + Turbo support |
| `web-console` | `~> 3.7` | `~> 4.2` | Rails 6+ wymaga 4.x |
| `rspec-rails` | `~> 4.0` | `~> 6.0` | Rails 7 support |
| `factory_bot_rails` | `~> 5.2` | `~> 6.2` | Ruby 3.x + Rails 7 |
| `capybara` | `~> 3.39, < 3.40` | `~> 3.39` | Usunięto sztuczną górną granicę |
| `simple_form` | `~> 5.1.0` | `~> 5.2` | Rails 7 support |
| `mail_form` | `~> 1.8.0` | `~> 1.10` | Rails 7 support |
| `mail` | `~> 2.7.1` | `~> 2.8` | Ruby 3.1 net-* stdlib split |
| `i18n-tasks` | `~> 0.9.5` | `~> 1.0` | Ruby 3.x compat |
| `rolify` | (no version) | `~> 6.0` | Rails 7 + explicit pin |
| `decent_exposure` | `'3.0.0'` | `'~> 3.0'` | Elastyczność na patch |
| `pg` | `~> 1.2.3` | `~> 1.5` | Aktualny, Ruby 3.1 compat |

### Konfiguracja environments — deprecacje Rails 7

**config/environments/development.rb:**
- `config.serve_static_files = true` → `config.public_file_server.enabled = true`
- Usunięto duplikat `raise_delivery_errors` (był dwa razy).

**config/environments/test.rb:**
- `config.serve_static_files` + `config.static_cache_control` → `config.public_file_server.enabled` + `config.public_file_server.headers`
- Usunięto `config.active_support.test_order = :random` (usunięte w Rails 6+).
- Dodano `config.active_support.disallowed_deprecation = :raise` (Rails 7 best practice).

**config/environments/production.rb:**
- `config.serve_static_files` → `config.public_file_server.enabled`
- Usunięto `config.secret_key_base = ENV["SECRET_KEY_BASE"]` (nadmiarowe — Rails czyta z `config/secrets.yml`).
- Usunięto zbędne `config.action_dispatch.rack_cache` (komentarz) i nieaktywne sekcje.
- Dodano `config.active_support.disallowed_deprecation = :log`.

### Kod aplikacji — safe_redirect_back (Rails 7)
`BackendController#safe_redirect_back` używało `redirect_to(request.referer.presence || fallback, options)`.
W Rails 7 `config.load_defaults 7.0` włącza `action_controller.raise_on_open_redirects = true`, co by rzucało `ActionController::Redirecting::UnsafeRedirectError` jeśli referer wskazuje inną domenę.

Zmieniono na `redirect_back(fallback_location:, **options)`:
- `redirect_back` jest bezpieczny (obsługuje brak referer przez fallback, od Rails 7 nie pozwala na zewnętrzne przekierowania domyślnie).
- Zachowuje przekazywanie `notice:` / `alert:` przez `**options`.

## Znane blokery pozostałe po Etapie 4
- **Paperclip** (`gem 'paperclip' ~> 6.1`): Paperclip jest od lat porzucony (archiwum GitHub). Wymaga migracji na ActiveStorage. Blokuje również `aws-sdk < 2.0` (stare SDK V1). → Etap 5.
- **`config/credentials.yml.enc`**: Aplikacja nadal używa `config/secrets.yml`. W środowiskach z podniesionym bezpieczeństwem zalecana migracja na credentials. → Etap 5.
- **`simple_form` po upgrade**: Należy ponownie uruchomić `rails generate simple_form:install` po deployu, aby odświeżyć szablony formularzy pod Bootstrap 3.
- **jQuery UJS vs rails-ujs**: `application.js` wymaga `jquery_ujs` (z `jquery-rails`), Rails 7 dostarcza `rails-ujs`. Oba mogą kolidować — zalecane przepięcie na `rails-ujs` i usunięcie `jquery_ujs`.

## Ograniczenia środowiska
- Lokalnie brak PostgreSQL — `bundle exec rspec` blokuje się na bazie.
- CI (Travis) weryfikuje pełny suite po push.
- Po checkout na `3.1.6` należy wykonać:
  1. `bundle install` (Gemfile.lock zostanie przeliczony ze zera — stary lock z Rails 5.2/Ruby 2.7 jest niekompatybilny).
  2. `bundle exec rails db:migrate` (jeśli pending migrations).
  3. `bundle exec rspec`.

## Weryfikacja lokalna (po instalacji Ruby 3.1.6 + bundler 2.4)
```bash
bundle exec ruby -e "require './config/boot'; require 'rails/all'; puts 'Rails ' + Rails.version + ' / Ruby ' + RUBY_VERSION + ' boot OK'"
# oczekiwane: Rails 7.0.x / Ruby 3.1.6 boot OK
```

## Status Etapu 4
Etap 4 **wykonany konfiguracyjnie i kodowo**:
- Gemfile zaktualizowany do Rails `7.0.8` / Ruby `3.1.6`.
- Wszystkie konfiguracje environment zaktualizowane do Rails 7 API.
- `config.load_defaults 7.0` włączony.
- Deprecated gemy usunięte.
- `safe_redirect_back` bezpieczny dla Rails 7 open-redirect protection.
- `bundle exec rspec` zablokowane lokalnie brakiem PostgreSQL; CI (Travis) weryfikuje pełny suite.
