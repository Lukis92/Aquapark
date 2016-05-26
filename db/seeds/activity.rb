ZONE = %w(A B C D E F).freeze
40.times do
  Activity.create!(
    name: Faker::Lorem.word,
    description: Faker::Lorem.sentence(3, true, 4),
    active: Faker::Boolean.boolean,
    date: Faker::Time.between('2016-01-01', '2016-07-01'),
    start_on: Faker::Time.between(1.days.ago, Date.today, :all),
    end_on: Faker::Time.between(1.days.ago, Date.today, :all),
    pool_zone: ZONE.sample,
    max_people: Faker::Number.number(2)
  )
end

p "Created #{Activity.count} activities"
