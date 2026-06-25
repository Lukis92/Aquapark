FactoryBot.define do
  factory :vacation do
    start_at { Date.today + 1 }
    end_at   { Date.today + 5 }
    free     { false }
    association :person, factory: :trainer

    after(:build) do |vacation|
      unless vacation.person&.persisted?
        trainer = create(:trainer)
        vacation.person    = trainer
        vacation.person_id = trainer.id
      end
    end
  end
end
