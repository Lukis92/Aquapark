30.times do
  Vacation.create!(
    start_at: Faker::Time.forward(1, :morning),
    end_at: Faker::Time.forward(1, :afternoon),
    free: Faker::Boolean.boolean,
    reason: Faker::Lorem.sentence,
    person_id: rand(53..115),
    accepted: Faker::Boolean.boolean
  )
end
p "Created #{Vacation.count} vacations"
