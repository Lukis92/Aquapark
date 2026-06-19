FactoryBot.define do
  factory :comment do
    body { 'Świetny wpis.' }
    association :person, factory: :client
    association :news
  end
end
