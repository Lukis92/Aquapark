# Rozwiązanie blokerów (post-Etap 4)

Data wykonania: `2026-06-19`

## Bloker 1: Paperclip → ActiveStorage

### Problem
`paperclip ~> 6.1` jest archiwizowanym gemem (brak aktualizacji od 2021). Używał `aws-sdk < 2.0` (AWS SDK V1, EOL). Plik na S3 był przechowywany pod ścieżką `/:class/:attachment/:id_partition/:style/:filename`.

### Rozwiązanie kodowe

**Gemfile:**
- Usunięto: `paperclip`, `aws-sdk < 2.0`
- Dodano: `aws-sdk-s3 ~> 1.0`, `image_processing ~> 1.12`

**`config/storage.yml`** (nowy plik):
```yaml
test:
  service: Disk
amazon:
  service: S3
  access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
  region: <%= ENV['AWS_REGION'] || 'us-east-1' %>
  bucket: <%= ENV['AWS_BUCKET_NAME'] %>
```

**`config/application.rb`:**
- Dodano `config.active_storage.variant_processor = :mini_magick`

**Environments:** `config.active_storage.service` per środowisko (`:amazon` dev/prod, `:test` test).

**`db/migrate/20260619000001_create_active_storage_tables.rb`:**
- Tabele: `active_storage_blobs`, `active_storage_attachments`, `active_storage_variant_records`

**`app/models/person.rb`:**
```ruby
# Przed:
has_attached_file :profile_image, styles: { medium: '300x300>', thumb: '100x100>' },
                                  default_url: '/images/user_default.png',
                                  storage: :s3, bucket: 'aquapark-project'
validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\Z/
validate :profile_image_size

# Po:
has_one_attached :profile_image do |attachable|
  attachable.variant :medium, resize_to_limit: [300, 300]
  attachable.variant :thumb,  resize_to_limit: [100, 100]
end
validates :profile_image,
          content_type: { in: /\Aimage\/.*\z/, message: 'musi być obrazem' },
          size: { less_than: 5.megabytes, message: 'powinno ważyć mniej niż 5MB' },
          if: -> { profile_image.attached? }
```

**`app/controllers/backend/people_controller.rb` (`remove_photo`):**
```ruby
# Przed:
@person.profile_image.destroy
@person.update(profile_image_file_name: nil, ...)

# Po:
@person.profile_image.purge
```

**Widoki** (4 pliki) — zamieniono `.url(:medium)` → `.variant(:medium)` + guard `attached?` z fallbackiem do `/images/user_default.png`:
- `app/views/backend/people/show.html.slim`
- `app/views/backend/people/edit.html.slim`
- `app/views/backend/comments/_comment.html.slim`
- `app/views/backend/individual_trainings/choose_trainer.html.slim`

**`config/initializers/paperclip.rb`** — wyczyszczony (pusty, zawiera tylko komentarz).

### Migracja danych S3

Stare pliki na S3 pozostają w ścieżkach Paperclip. Po deploymencie:

```bash
bundle exec rails paperclip:migrate_to_activestorage
```

Task (`lib/tasks/paperclip_to_activestorage.rake`) iteruje po Person records, pobiera oryginał z S3 (stara ścieżka Paperclip) i attachuje przez ActiveStorage. Jest idempotentny — pomija osoby które mają już załączony plik.

Po weryfikacji że migracja zadziałała, można usunąć stare kolumny:

```bash
rails g migration DropPaperclipColumnsFromPeople \
  profile_image_file_name:string \
  profile_image_content_type:string \
  profile_image_file_size:integer \
  profile_image_updated_at:datetime
# edytuj migrację żeby używała remove_column
rails db:migrate
```

### Env vars po zmianie

| Stara (Paperclip dev) | Nowa (ActiveStorage) |
|----------------------|---------------------|
| `S3_BUCKET_NAME` | `AWS_BUCKET_NAME` |
| `AWS_ACCESS_KEY_ID` | `AWS_ACCESS_KEY_ID` (bez zmian) |
| `AWS_SECRET_ACCESS_KEY` | `AWS_SECRET_ACCESS_KEY` (bez zmian) |
| — | `AWS_REGION` (nowe, domyślnie `us-east-1`) |

---

## Bloker 2: jquery_ujs → rails-ujs

### Problem
`application.js` używało `//= require jquery_ujs` (jQuery-based UJS adapter z gemu `jquery-rails`). Rails 7 dostarcza `rails-ujs` wbudowany w `actionview`. Oba załadowane razem powodują double-binding eventów (`data-remote`, `data-confirm` itp.).

### Rozwiązanie
`app/assets/javascripts/application.js`:
```js
// Przed:
//= require jquery_ujs

// Po:
//= require rails-ujs
```

`jquery-rails` zostaje w Gemfile (dostarcza jQuery i jQuery UI), ale przestaje być źródłem adaptera UJS.

---

## Bloker 3: config/secrets.yml — ERB syntax

### Problem
Plik `config/secrets.yml` zawierał literalne stringi zamiast odczytywać zmienne środowiskowe:
```yaml
secret_key_base: ENV['SECRET_KEY_BASE']  # dosłowny string!
```

### Rozwiązanie
Zawinięto wartości w ERB tags:
```yaml
secret_key_base: <%= ENV['SECRET_KEY_BASE'] %>
```

Dotyczy `stripe_publishable_key`, `stripe_secret_key` i `secret_key_base` we wszystkich środowiskach.

Plik `secrets.yml` jest nadal obsługiwany przez Rails 7.0. Pełna migracja na `credentials.yml.enc` jest opcjonalna.
