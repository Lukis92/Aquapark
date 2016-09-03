CZAS = %w(30 60 90).freeze
1.times do
  TrainingCost.create!(
    duration: CZAS.sample,
    cost: Faker::Number.decimal(3, 2)
  )
end
p "Created #{TrainingCost.count} training costs"
