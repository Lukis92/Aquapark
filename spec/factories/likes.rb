FactoryGirl.define do
  factory :like do
    like true
    association :person, factory: :client
    association :news
  end
end
