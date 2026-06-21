# db/seeds/bulk_data.rb
# Dodaje 100 pracowników różnych typów + 100 klientów z powiązanymi danymi
# Uruchom: rails runner db/seeds/bulk_data.rb

require 'faker'

BULK_DAYS  = %w(Poniedziałek Wtorek Środa Czwartek Piątek Sobota Niedziela).freeze
BULK_ZONES = %w(A B C D E F).freeze
BULK_ACTIVITY_NAMES = [
  'Aqua Aerobik', 'Fit Girls', 'Water Polo Junior', 'Swim & Tone',
  'Baby Swim', 'Open Water Training', 'Senior Swim', 'Fat Burner',
  'Aqua Yoga', 'Deep Water Running', 'Aqua Zumba', 'Nurkowanie rekreacyjne',
  'Pływanie dla dzieci', 'Aqua Power', 'Water Fitness', 'Hydro Spinning',
  'Aqua Dance', 'Interval Swimming', 'Technika pływania', 'Swim Masters'
].freeze
BULK_VACATION_REASONS = [
  'Urlop wypoczynkowy', 'Urlop na żądanie', 'Urlop okolicznościowy',
  'Szkolenie zewnętrzne', 'Delegacja', 'Opieka nad dzieckiem'
].freeze

def bulk_unique_pesel
  loop do
    digits = Array.new(11) { rand(0..9) }
    digits[0] = rand(1..9) # nie zaczynaj od 0
    p = digits.join
    return p unless Person.exists?(pesel: p)
  end
end

def bulk_unique_email(prefix, suffix)
  loop do
    e = "#{prefix}_#{suffix}_#{SecureRandom.hex(4)}@aquapark.test"
    return e.downcase unless Person.exists?(email: e.downcase)
  end
end

def bulk_random_date_of_birth(min_age, max_age)
  Faker::Date.between(
    from: (Date.today - max_age.years).to_s,
    to:   (Date.today - min_age.years).to_s
  )
end

def bulk_random_hiredate
  Faker::Date.between(from: '2018-01-01', to: (Date.today - 30).to_s)
end

puts "=== Tworzenie danych testowych ==="
puts "Istniejące rekordy: #{Person.count} osób, #{WorkSchedule.count} grafiów"

# ─── 1. KOSZTY TRENINGÓW ────────────────────────────────────────────────────
puts "\n[1/9] Koszty treningów..."
[
  { duration: 30, cost: 50.00 },
  { duration: 60, cost: 90.00 },
  { duration: 90, cost: 130.00 }
].each do |attrs|
  TrainingCost.find_or_create_by!(duration: attrs[:duration]) { |tc| tc.cost = attrs[:cost] }
end
training_cost_ids = TrainingCost.pluck(:id)
puts "  TrainingCosts: #{TrainingCost.count}"

# ─── 2. KLIENCI (100) ───────────────────────────────────────────────────────
puts "\n[2/9] Klienci (100)..."
100.times do |i|
  Client.create!(
    pesel:         bulk_unique_pesel,
    first_name:    Faker::Name.first_name,
    last_name:     Faker::Name.last_name,
    date_of_birth: bulk_random_date_of_birth(16, 75),
    email:         bulk_unique_email('klient', i),
    password:      'password'
  )
end
puts "  Klientów łącznie: #{Client.count}"

# ─── 3. RECEPCJONIŚCI (15) ──────────────────────────────────────────────────
puts "\n[3/9] Recepcjoniści (15)..."
15.times do |i|
  Receptionist.create!(
    pesel:         bulk_unique_pesel,
    first_name:    Faker::Name.first_name,
    last_name:     Faker::Name.last_name,
    date_of_birth: bulk_random_date_of_birth(20, 55),
    email:         bulk_unique_email('recepcjonista', i),
    password:      'password',
    salary:        rand(3500..5200).to_f,
    hiredate:      bulk_random_hiredate
  )
end
puts "  Recepcjonistów łącznie: #{Receptionist.count}"

# ─── 4. RATOWNICY (25) ──────────────────────────────────────────────────────
puts "\n[4/9] Ratownicy (25)..."
25.times do |i|
  Lifeguard.create!(
    pesel:         bulk_unique_pesel,
    first_name:    Faker::Name.first_name,
    last_name:     Faker::Name.last_name,
    date_of_birth: bulk_random_date_of_birth(20, 50),
    email:         bulk_unique_email('ratownik', i),
    password:      'password',
    salary:        rand(4000..6000).to_f,
    hiredate:      bulk_random_hiredate
  )
end
puts "  Ratowników łącznie: #{Lifeguard.count}"

# ─── 5. TRENERZY (60) ───────────────────────────────────────────────────────
puts "\n[5/9] Trenerzy (60)..."
60.times do |i|
  Trainer.create!(
    pesel:         bulk_unique_pesel,
    first_name:    Faker::Name.first_name,
    last_name:     Faker::Name.last_name,
    date_of_birth: bulk_random_date_of_birth(22, 55),
    email:         bulk_unique_email('trener', i),
    password:      'password',
    salary:        rand(4500..7500).to_f,
    hiredate:      bulk_random_hiredate
  )
end
puts "  Trenerów łącznie: #{Trainer.count}"

# ─── 6. GRAFIKI PRACY (dla wszystkich pracowników) ──────────────────────────
puts "\n[6/9] Grafiki pracy..."
ws_new = 0
Person.where.not(type: 'Client').find_each do |emp|
  existing_days = emp.work_schedules.pluck(:day_of_week)
  available_days = BULK_DAYS - existing_days
  next if available_days.empty?

  days_count = rand(3..[5, available_days.length].min)
  available_days.sample(days_count).each do |day|
    start_hour = rand(6..14)
    end_hour   = [start_hour + rand(4..8), 22].min
    next if end_hour - start_hour < 2

    WorkSchedule.create!(
      day_of_week: day,
      start_time:  format('%02d:00:00', start_hour),
      end_time:    format('%02d:00:00', end_hour),
      person_id:   emp.id
    )
    ws_new += 1
  end
end
puts "  Nowych grafiów: #{ws_new} (łącznie: #{WorkSchedule.count})"

# ─── 7. ZAJĘCIA GRUPOWE (dla trenerów z grafikami) ──────────────────────────
puts "\n[7/9] Zajęcia grupowe..."
act_ok = 0
act_skip = 0
Trainer.joins(:work_schedules).distinct.find_each do |trainer|
  schedules = trainer.work_schedules.to_a
  activities_count = rand(1..2)
  schedules.sample([activities_count, schedules.length].min).each do |ws|
    s_hour = ws.start_time.hour
    e_hour = ws.end_time.hour
    next if e_hour - s_hour < 2

    act_s = s_hour + rand(0..[e_hour - s_hour - 2, 0].max)
    act_e = act_s + rand(1..2)
    next if act_e > e_hour

    a = Activity.new(
      name:        BULK_ACTIVITY_NAMES.sample,
      description: "Profesjonalne zajęcia z doświadczonym instruktorem. #{Faker::Lorem.sentence(word_count: 5)}",
      active:      true,
      day_of_week: ws.day_of_week,
      start_on:    format('%02d:00:00', act_s),
      end_on:      format('%02d:00:00', act_e),
      pool_zone:   BULK_ZONES.sample,
      max_people:  rand(6..20),
      person_id:   trainer.id
    )
    if a.save
      act_ok += 1
    else
      act_skip += 1
    end
  end
end
puts "  Zajęć stworzono: #{act_ok}, pominięto (kolizje): #{act_skip} (łącznie: #{Activity.count})"

# ─── 8. TRENINGI INDYWIDUALNE ───────────────────────────────────────────────
puts "\n[8/9] Treningi indywidualne..."
trainers_ws = Trainer.joins(:work_schedules).distinct.to_a
clients_all  = Client.all.to_a
it_ok = 0

if trainers_ws.any? && clients_all.any? && training_cost_ids.any?
  # DAYS → Ruby wday: Poniedziałek=1, Wtorek=2, ..., Niedziela=0
  day_to_wday = {
    'Poniedziałek' => 1, 'Wtorek' => 2, 'Środa' => 3,
    'Czwartek' => 4, 'Piątek' => 5, 'Sobota' => 6, 'Niedziela' => 0
  }

  200.times do
    trainer = trainers_ws.sample
    ws      = trainer.work_schedules.sample
    client  = clients_all.sample
    tc      = TrainingCost.find(training_cost_ids.sample)

    wday_target = day_to_wday[ws.day_of_week]
    days_ahead  = ((wday_target - Date.today.wday) % 7)
    days_ahead  = 7 if days_ahead == 0
    training_date = Date.today + days_ahead + (rand(0..11) * 7)

    s_hour = ws.start_time.hour
    e_hour = ws.end_time.hour
    dur_h  = tc.duration.to_i / 60
    dur_m  = tc.duration.to_i % 60
    next if e_hour - s_hour < 1

    start_h = s_hour + rand(0..[e_hour - s_hour - 1, 0].max)
    end_h   = start_h + dur_h
    end_m   = dur_m
    next if end_h > e_hour

    it = IndividualTraining.new(
      date_of_training: training_date,
      client_id:        client.id,
      trainer_id:       trainer.id,
      start_on:         format('%02d:00:00', start_h),
      end_on:           format('%02d:%02d:00', end_h, end_m),
      training_cost_id: tc.id
    )
    it.save(validate: false)
    it_ok += 1 if it.persisted?
  end
end
puts "  Treningów indywidualnych: #{it_ok} (łącznie: #{IndividualTraining.count})"

# ─── 9. ZAPISY NA ZAJĘCIA + URLOPY ──────────────────────────────────────────
puts "\n[9/9] Zapisy na zajęcia i urlopy..."
activities_all = Activity.all.to_a
ap_ok = 0

if activities_all.any?
  Client.find_each do |client|
    activities_all.sample(rand(1..4)).each do |activity|
      dates = activity.next_n_days(4)
      next if dates.empty?

      date = dates.sample
      next if ActivitiesPerson.exists?(person_id: client.id, activity_id: activity.id, date: date)

      ap = ActivitiesPerson.create(person_id: client.id, activity_id: activity.id, date: date)
      ap_ok += 1 if ap.persisted?
    end
  end
end
puts "  Zapisów na zajęcia: #{ap_ok} (łącznie: #{ActivitiesPerson.count})"

vac_ok = 0
Person.where.not(type: 'Client').find_each do |emp|
  base_date = Date.today + 2
  rand(1..3).times do
    start_at = base_date + rand(3..30)
    end_at   = start_at + rand(5..14)
    v = Vacation.new(
      start_at:  start_at,
      end_at:    end_at,
      free:      [true, false].sample,
      reason:    BULK_VACATION_REASONS.sample,
      person_id: emp.id,
      accepted:  [true, true, false].sample
    )
    v.save(validate: false)
    vac_ok += 1 if v.persisted?
    base_date = end_at + rand(1..7)
  end
end
puts "  Urlopów: #{vac_ok} (łącznie: #{Vacation.count})"

# ─── PODSUMOWANIE ───────────────────────────────────────────────────────────
puts "\n" + "=" * 40
puts "GOTOWE! Aktualne liczby w bazie:"
puts "  Klienci:               #{Client.count}"
puts "  Recepcjoniści:         #{Receptionist.count}"
puts "  Ratownicy:             #{Lifeguard.count}"
puts "  Trenerzy:              #{Trainer.count}"
puts "  Grafiki pracy:         #{WorkSchedule.count}"
puts "  Zajęcia grupowe:       #{Activity.count}"
puts "  Treningi ind.:         #{IndividualTraining.count}"
puts "  Zapisy na zajęcia:     #{ActivitiesPerson.count}"
puts "  Urlopy:                #{Vacation.count}"
puts "=" * 40
puts "\nLogowanie (wszyscy z hasłem 'password'):"
puts "  Manager:  manager@youremail.com"
puts "  Klient:   klient_0_****@aquapark.test (sprawdź w konsoli: Client.last.email)"
