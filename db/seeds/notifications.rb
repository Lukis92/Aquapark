# db/seeds/notifications.rb
# Generuje przykładowe powiadomienia na podstawie istniejących danych
# Uruchom: rails runner db/seeds/notifications.rb

puts "=== Generowanie powiadomień ==="
puts "Istniejące powiadomienia: #{Notification.count}"

manager = Manager.first
if manager.nil?
  puts "BŁĄD: Brak managera w bazie. Uruchom najpierw db/seeds/manager.rb"
  exit
end

created = 0

# ─── 1. URLOPY ─────────────────────────────────────────────────────────────────
puts "\n[1/5] Urlopy (accepted/rejected)..."
Vacation.includes(:person).find_each do |vacation|
  next unless vacation.person

  if vacation.accepted?
    Notification.create!(
      person:     vacation.person,
      actor:      manager,
      kind:       'vacation_accepted',
      message:    "Urlop od #{vacation.start_at.strftime('%d.%m.%Y')} do #{vacation.end_at.strftime('%d.%m.%Y')} został zaakceptowany.",
      notifiable: vacation,
      created_at: vacation.start_at - rand(1..10).days,
      read_at:    [nil, nil, Time.current - rand(1..72).hours].sample
    )
    created += 1
  else
    Notification.create!(
      person:     vacation.person,
      actor:      manager,
      kind:       'vacation_rejected',
      message:    "Urlop od #{vacation.start_at.strftime('%d.%m.%Y')} do #{vacation.end_at.strftime('%d.%m.%Y')} został odrzucony.",
      notifiable: vacation,
      created_at: vacation.start_at - rand(1..5).days,
      read_at:    [nil, Time.current - rand(1..48).hours].sample
    )
    created += 1
  end
end
puts "  Powiadomień z urlopów: #{created}"

# ─── 2. GRAFIKI PRACY ──────────────────────────────────────────────────────────
puts "\n[2/5] Grafiki pracy..."
ws_count = 0
WorkSchedule.includes(:person).find_each do |ws|
  next unless ws.person

  Notification.create!(
    person:     ws.person,
    actor:      manager,
    kind:       'work_schedule_added',
    message:    "Dodano grafik pracy na #{ws.day_of_week}: #{ws.start_time.strftime('%H:%M')}–#{ws.end_time.strftime('%H:%M')}.",
    notifiable: ws,
    created_at: Time.current - rand(7..180).days,
    read_at:    [nil, Time.current - rand(1..120).hours].sample
  )
  ws_count += 1
end
puts "  Powiadomień z grafiów: #{ws_count}"
created += ws_count

# ─── 3. TRENINGI INDYWIDUALNE ─────────────────────────────────────────────────
puts "\n[3/5] Treningi indywidualne (assigned)..."
it_count = 0
IndividualTraining.includes(:trainer, :client).find_each do |it|
  next unless it.trainer && it.client

  training_info = "#{it.date_of_training.strftime('%d.%m.%Y')} #{it.start_on.strftime('%H:%M')}–#{it.end_on.strftime('%H:%M')}"

  # Powiadomienie dla trenera
  Notification.create!(
    person:     it.trainer,
    actor:      it.client,
    kind:       'individual_training_assigned',
    message:    "Przypisano nowy trening indywidualny: #{training_info} z klientem #{it.client.full_name}.",
    notifiable: it,
    created_at: it.date_of_training - rand(1..14).days,
    read_at:    it.date_of_training < Date.today ? (Time.current - rand(1..48).hours) : nil
  )
  it_count += 1

  # Powiadomienie dla managera (klient kupił trening)
  Notification.create!(
    person:     manager,
    actor:      it.client,
    kind:       'individual_training_assigned',
    message:    "Klient #{it.client.full_name} zarezerwował trening z #{it.trainer.full_name} na #{training_info}.",
    notifiable: it,
    created_at: it.date_of_training - rand(1..14).days,
    read_at:    [nil, nil, Time.current - rand(1..72).hours].sample
  )
  it_count += 1
end
puts "  Powiadomień z treningów: #{it_count}"
created += it_count

# ─── 4. ZAPISY NA ZAJĘCIA GRUPOWE ─────────────────────────────────────────────
puts "\n[4/5] Zapisy na zajęcia grupowe..."
ap_count = 0
ActivitiesPerson.includes(:person, activity: :person).find_each do |ap|
  next unless ap.person && ap.activity

  recipient = ap.activity.person || manager

  Notification.create!(
    person:     recipient,
    actor:      ap.person,
    kind:       'activity_signup',
    message:    "#{ap.person.full_name} zapisał(a) się na zajęcia \"#{ap.activity.name}\" (#{ap.date.strftime('%d.%m.%Y')}).",
    notifiable: ap.activity,
    created_at: ap.date - rand(1..7).days,
    read_at:    ap.date < Date.today ? (Time.current - rand(1..96).hours) : nil
  )
  ap_count += 1

  # Dodatkowe powiadomienie do managera jeśli trener jest odbiorcą
  if recipient != manager
    Notification.create!(
      person:     manager,
      actor:      ap.person,
      kind:       'activity_signup',
      message:    "#{ap.person.full_name} zapisał(a) się na zajęcia \"#{ap.activity.name}\" (#{ap.date.strftime('%d.%m.%Y')}).",
      notifiable: ap.activity,
      created_at: ap.date - rand(1..7).days,
      read_at:    [nil, nil, Time.current - rand(1..72).hours].sample
    )
    ap_count += 1
  end
end
puts "  Powiadomień z zapisów: #{ap_count}"
created += ap_count

# ─── 5. ZAKUPY BILETÓW/KARNETÓW ──────────────────────────────────────────────
puts "\n[5/5] Zakupy biletów i karnetów..."
bd_count = 0
BoughtDetail.includes(:person, :entry_type).find_each do |bd|
  next unless bd.person && bd.entry_type

  Notification.create!(
    person:     manager,
    actor:      bd.person,
    kind:       'ticket_purchased',
    message:    "#{bd.person.full_name} kupił(a) #{bd.entry_type.kind_details} (#{bd.entry_type.kind}) za #{bd.cost} zł.",
    notifiable: bd,
    created_at: bd.bought_data,
    read_at:    [nil, nil, Time.current - rand(1..120).hours].sample
  )
  bd_count += 1
end
puts "  Powiadomień z zakupów: #{bd_count}"
created += bd_count

# ─── PODSUMOWANIE ─────────────────────────────────────────────────────────────
puts "\n" + "=" * 40
puts "GOTOWE! Stworzono #{created} powiadomień."
puts "  Łącznie w bazie: #{Notification.count}"
puts "  Nieprzeczytanych: #{Notification.unread.count}"
puts "=" * 40
