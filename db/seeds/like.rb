100.times do
  Like.create!(
    like: Faker::Boolean.boolean,
    person_id: Faker::Number.between(1, 115),
    news_id: Faker::Number.between(1, 60)
  )
end
p "Created #{Like.count} likes"
