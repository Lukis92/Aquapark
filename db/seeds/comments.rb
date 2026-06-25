# db/seeds/comments.rb
# Generuje komentarze do istniejących artykułów
# Uruchom: rails runner db/seeds/comments.rb

require 'faker'

news_ids   = News.pluck(:id)
person_ids = Person.pluck(:id)

if news_ids.empty? || person_ids.empty?
  puts "BŁĄD: Brak newsów lub osób. Uruchom najpierw news.rb i bulk_data.rb"
  exit
end

70.times do
  Comment.create!(
    body:      Faker::Lorem.paragraph(sentence_count: rand(1..4)),
    news_id:   news_ids.sample,
    person_id: person_ids.sample
  )
end

puts "Komentarze: #{Comment.count}"
