30.times do
  IndividualTraining.create!(
    date_of_training: Faker::Time.forward(23, :all),
    client_id: Faker::Number.between(2, 51),
    trainer_id: Faker::Number.between(92, 112),
    start_on: Faker::Time.forward(1, :morning),
    end_on: Faker::Time.forward(1, :morning),
    training_cost_id: rand(1..3)
  )
end
p "Created #{IndividualTraining.count} trainings"
