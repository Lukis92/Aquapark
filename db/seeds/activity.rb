# DNI_TYGODNIA = %w(Poniedziałek Wtorek Środa Czwartek Piatek Sobota Niedziela).freeze
# ZONE = %w(A B C D E F).freeze
Activity.create!(
  name: 'Fit Girls',
  description: 'Ciekawe zajęcia dla kobiet',
  active: 'true',
  day_of_week: 'Poniedziałek',
  start_on: '08:00',
  end_on: '09:00',
  pool_zone: 'A',
  max_people: '10',
  person_id: '95'
)

Activity.create!(
  name: 'Swim Aerobik',
  description: 'Ćwiczenia rozciągające całe ciało.',
  active: 'true',
  day_of_week: 'Wtorek',
  start_on: '10:00',
  end_on: '11:30',
  pool_zone: 'B',
  max_people: '5',
  person_id: '96'
)

Activity.create!(
  name: 'Fat Burner',
  description: 'Ćwiczenia mające na celu zgubienie zbędnych kilogramów.',
  active: 'true',
  day_of_week: 'Środa',
  start_on: '11:00',
  end_on: '12:00',
  pool_zone: 'C',
  max_people: '30',
  person_id: '97'
)

1.times do
  Activity.create!(
    name: Faker::Lorem.word,
    description: Faker::Lorem.sentence(3, true, 4),
    active: Faker::Boolean.boolean,
    day_of_week: DNI_TYGODNIA.sample,
    start_on: Faker::Time.between(1.days.ago, Date.today, :all),
    end_on: Faker::Time.between(1.days.ago, Date.today, :all),
    pool_zone: ZONE.sample,
    max_people: Faker::Number.number(2),
    person_id: rand(95..115)
  )
end

p "Created #{Activity.count} activities"
