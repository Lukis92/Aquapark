70.times do
  Comment.create!(
    body: Faker::Lorem.paragraph(2, false, 5),
    news_id: Faker::Number.between(1, 60),
    person_id: Faker::Number.between(1, 115)
  )
end
p "Created #{Comment.count} comments"
