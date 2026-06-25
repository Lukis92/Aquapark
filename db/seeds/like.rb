# db/seeds/like.rb
# Generuje polubienia/niepolubienia do istniejących artykułów
# Uruchom: rails runner db/seeds/like.rb

news_ids   = News.pluck(:id)
person_ids = Person.pluck(:id)

if news_ids.empty? || person_ids.empty?
  puts "BŁĄD: Brak newsów lub osób. Uruchom najpierw news.rb i bulk_data.rb"
  exit
end

created = 0
100.times do
  news_id   = news_ids.sample
  person_id = person_ids.sample
  next if Like.exists?(news_id: news_id, person_id: person_id)

  Like.create!(like: [true, false].sample, news_id: news_id, person_id: person_id)
  created += 1
end

puts "Polubienia: #{Like.count} (nowych: #{created})"
