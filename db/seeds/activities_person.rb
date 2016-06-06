40.times do
  ActivitiesPerson.create!(
    person_id: rand(2..52),
    activity_id: rand(1..40),
    date: Faker::Date.forward(23)
  )
end

p "Created #{ActivitiesPerson.count} activities person"
