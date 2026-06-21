# db/seeds/bought_history.rb
# Dodaje ~200 rekordów historii zakupów biletów i karnetów
# Uruchom: rails runner db/seeds/bought_history.rb

puts "=== Seed: historia zakupów ==="

# ── 1. Upewnij się, że istnieją typy wejściówek ─────────────────────────────
default_entry_types = [
  { kind: 'Bilet', kind_details: 'Bilet normalny',    price: 25.00,  description: 'Jednorazowe wejście dla dorosłych' },
  { kind: 'Bilet', kind_details: 'Bilet ulgowy',      price: 15.00,  description: 'Dla dzieci i seniorów' },
  { kind: 'Bilet', kind_details: 'Bilet rodzinny',    price: 60.00,  description: 'Dla rodziny 2+2' },
  { kind: 'Bilet', kind_details: 'Bilet weekendowy',  price: 35.00,  description: 'Ważny w weekendy' },
  { kind: 'Karnet', kind_details: 'Karnet miesięczny', price: 120.00, description: 'Dostęp przez 30 dni' },
  { kind: 'Karnet', kind_details: 'Karnet kwartalny', price: 320.00, description: 'Dostęp przez 90 dni' },
  { kind: 'Karnet', kind_details: 'Karnet roczny',    price: 998.00, description: 'Dostęp przez 365 dni' },
  { kind: 'Karnet', kind_details: 'Karnet rodzinny',  price: 280.00, description: 'Karnet dla 4 osób na 30 dni' },
]

default_entry_types.each do |attrs|
  EntryType.find_or_create_by!(kind: attrs[:kind], kind_details: attrs[:kind_details]) do |et|
    et.price       = attrs[:price]
    et.description = attrs[:description]
  end
end

tickets = EntryType.tickets.to_a
passes  = EntryType.passes.to_a
clients = Client.all.to_a

if clients.empty?
  puts "Brak klientów w bazie — uruchom najpierw db/seeds/bulk_data.rb"
  exit
end

puts "Typy wejściówek: #{EntryType.count} (biletów: #{tickets.count}, karnetów: #{passes.count})"
puts "Klientów: #{clients.count}"

# ── 2. Słownik czasu trwania (dni) per kind_details ────────────────────────
DURATION_DAYS = {
  'Bilet normalny'   => 1,
  'Bilet ulgowy'     => 1,
  'Bilet rodzinny'   => 1,
  'Bilet weekendowy' => 2,
  'Karnet miesięczny' => 30,
  'Karnet kwartalny'  => 90,
  'Karnet roczny'     => 365,
  'Karnet rodzinny'   => 30,
}.freeze

def duration_for(entry_type)
  DURATION_DAYS[entry_type.kind_details] || (entry_type.kind == 'Bilet' ? 1 : 30)
end

# ── 3. Generowanie rekordów ─────────────────────────────────────────────────
created = 0
skipped = 0

# Rozłóż zakupy na ostatnie 18 miesięcy + kilka bieżących/przyszłych
date_range_start = Date.today - 18.months

200.times do
  entry_type = ([*tickets] * 3 + [*passes]).sample  # bilety 3x częściej
  client     = clients.sample
  days       = duration_for(entry_type)

  # Losuj datę zakupu z ostatnich 18 miesięcy
  bought_on  = date_range_start + rand(0..(Date.today - date_range_start).to_i)
  start_on   = bought_on
  end_on     = start_on + days

  bd = BoughtDetail.new(
    entry_type_id: entry_type.id,
    person_id:     client.id,
    bought_data:   bought_on.to_time,
    start_on:      start_on,
    end_on:        end_on,
    cost:          entry_type.price
  )

  if bd.save(validate: false)
    created += 1
  else
    skipped += 1
  end
end

puts "\nGotowe!"
puts "  Dodano:    #{created} rekordów"
puts "  Pominięto: #{skipped}"
puts "  Łącznie w bazie: #{BoughtDetail.count}"
puts "\nPrzykłady:"
BoughtDetail.order('bought_data DESC').limit(5).each do |bd|
  puts "  #{bd.person.full_name} | #{bd.entry_type.kind_details} | #{bd.start_on} – #{bd.end_on} | #{bd.cost} zł"
end
