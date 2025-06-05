FactoryGirl.define do
  factory :bought_detail do
    association :entry_type
    association :person, factory: :client
    cost 50.0
    days 7
    start_on { Date.today }
  end
end
