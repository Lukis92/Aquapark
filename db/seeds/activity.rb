DNI_TYGODNIA = %w(Poniedziałek Wtorek Środa Czwartek Piatek Sobota Niedziela).freeze
ZONE = %w(A B C D E F).freeze
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
