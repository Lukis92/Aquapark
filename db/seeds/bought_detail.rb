400.times do
  BoughtDetail.create!(
    bought_data: Faker::Time.between(300.days.ago, Date.today, :all),
    end_on: Faker::Time.forward(300, :all),
    entry_type_id: rand(1..10),
    person_id: rand(2..52),
    cost: Faker::Number.decimal(3, 2),
    start_on: Faker::Time.between(300.days.ago, Date.today, :all),
  )
end
p "Created #{BoughtDetail.count} bought details"
