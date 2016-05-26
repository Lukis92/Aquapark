30.times do
  IndividualTraining.create!(
    date_of_training: Faker::Time.forward(23, :all),
    client_id: Faker::Number.between(2, 51),
    trainer_id: Faker::Number.between(92, 112),
    start_on:
    end_on:
    training_cost:
  )
end
p "Created #{IndividualTraining.count} trainings"
