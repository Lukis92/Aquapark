require 'date'

FactoryBot.define do
  factory :individual_training do
    date_of_training { Date.today.next_week.advance(days: 1) }
    association :client, factory: :client
    association :trainer, factory: :trainer
    start_on { '12:30' }
    end_on   { '13:30' }
    association :training_cost, factory: :tc2

    after(:build) do |training|
      # Ensure trainer is persisted (build strategy creates unsaved objects)
      unless training.trainer&.persisted?
        trainer = create(:trainer)
        training.trainer    = trainer
        training.trainer_id = trainer.id
      end
      # Always ensure the trainer has a work_schedule for the training day.
      # With FactoryBot's create strategy, associations are already persisted but have
      # no work_schedules, so we create one when the trainer has none at all.
      if training.trainer&.persisted? && training.date_of_training.present?
        polish_days = %w[Niedziela Poniedziałek Wtorek Środa Czwartek Piątek Sobota]
        polish_day = polish_days[training.date_of_training.wday]
        trainer_record = Person.find(training.trainer_id)
        if trainer_record.work_schedules.empty?
          WorkSchedule.create!(
            person:      trainer_record,
            day_of_week: polish_day,
            start_time:  '08:00',
            end_time:    '20:00'
          )
        end
      end
      # Ensure client is persisted
      unless training.client&.persisted?
        client = create(:client)
        training.client    = client
        training.client_id = client.id
      end
      # Ensure training_cost is persisted
      unless training.training_cost&.persisted?
        tc = create(:tc2)
        training.training_cost    = tc
        training.training_cost_id = tc.id
      end
    end

    factory :ind do
      association :client, factory: :client1
      association :trainer, factory: :trainer1
      start_on { '11:00' }
      end_on   { '12:00' }
    end

    factory :ind2 do
      start_on { '10:30' }
      end_on   { '11:30' }
    end
  end
end
