SCOPE = %w(wszyscy pracownicy ratownicy trenerzy recepcjoniści klienci).freeze
30.times do
  News.create!(
    title: Faker::Lorem.sentence,
    content: Faker::Lorem.paragraph(40, true, 40),
    scope: SCOPE.sample,
    person_id: Faker::Number.between(52, 112)
  )
end
p "Created #{News.count} news"
