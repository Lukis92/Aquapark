FactoryGirl.define do
  factory :news do
    title 'Nowy wpis'
    content 'Długi opis wpisu'
    scope 'public'
    association :person, factory: :trainer
  end
end
