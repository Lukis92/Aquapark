# db/seeds/news.rb
# Generuje artykuły aktualności przypisane do istniejących pracowników
# Uruchom: rails runner db/seeds/news.rb

require 'faker'

NEWS_SCOPES = %w[wszyscy pracownicy ratownicy trenerzy recepcjoniści klienci].freeze

staff_ids = Person.where.not(type: 'Client').pluck(:id)
if staff_ids.empty?
  puts "BŁĄD: Brak pracowników. Uruchom najpierw bulk_data.rb"
  exit
end

60.times do
  News.create!(
    title:     Faker::Lorem.sentence(word_count: rand(4..8)),
    content:   Faker::Lorem.paragraphs(number: rand(3..8)).join("\n\n"),
    scope:     NEWS_SCOPES.sample,
    person_id: staff_ids.sample
  )
end

puts "Aktualności: #{News.count}"
