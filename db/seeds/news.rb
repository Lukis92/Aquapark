SCOPE = %w(wszyscy pracownicy ratownicy trenerzy recepcjoniści klienci).freeze
60.times do
  News.create!(
    title: Faker::Lorem.sentence,
    content: Faker::Lorem.paragraph(40, true, 40),
    scope: SCOPE.sample,
    person_id: Faker::Number.between(53, 73)
  )
end
p "Created #{News.count} news"
