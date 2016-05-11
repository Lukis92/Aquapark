30.times do
  IndividualTraining.create!(
    cost: Faker::Number.decimal(3, 2),
    date_of_training: Faker::Time.forward(23, :all),
    client_id: Faker::Number.between(2, 51),
    trainer_id: Faker::Number.decimal(92, 112)
  )
end
p "Created #{IndividualTraining.count} trainings"
