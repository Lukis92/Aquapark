FactoryBot.define do
  factory :notification do
    association :person, factory: :trainer
    kind    { 'vacation_accepted' }
    message { 'Twój urlop został zaakceptowany.' }
    read_at { nil }
  end
end
