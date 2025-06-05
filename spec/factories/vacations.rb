FactoryGirl.define do
  factory :vacation do
    start_at { Date.today + 1 }
    end_at { Date.today + 5 }
    association :person, factory: :trainer
  end
end
