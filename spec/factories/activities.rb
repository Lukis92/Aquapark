require 'faker'

FactoryBot.define do
  factory :activity do
    name        { 'Fit Girls' }
    description { 'ss' }
    active      { true }
    day_of_week { 'Wtorek' }
    start_on    { '12:00' }
    end_on      { '13:00' }
    pool_zone   { 'B' }
    max_people  { 20 }
    association :person, factory: :trainer

    after(:build) do |activity|
      unless activity.person&.persisted?
        trainer = create(:trainer)
        activity.person    = trainer
        activity.person_id = trainer.id
      end
      if activity.person&.persisted?
        unless activity.person.work_schedules.exists?(day_of_week: activity.day_of_week)
          WorkSchedule.create!(
            person:      activity.person,
            day_of_week: activity.day_of_week,
            start_time:  '08:00',
            end_time:    '20:00'
          )
        end
      end
    end

    factory :first do
      name        { 'Swim Cycle' }
      description { 'Zajęcia z rowerami wodnymi.' }
      active      { true }
      day_of_week { 'Wtorek' }
      start_on    { '11:30' }
      end_on      { '12:30' }
    end

    factory :second do
      name        { 'Aqua Crossfit' }
      description { 'Wodny crossfit dla każdego' }
      active      { true }
      day_of_week { 'Wtorek' }
      start_on    { '12:40' }
      end_on      { '13:40' }
      pool_zone   { 'C' }
      max_people  { '30' }
    end

    factory :activity1 do
      start_on { '11:30' }
      end_on   { '12:30' }
    end

    factory :activity2 do
      day_of_week { 'Wtorek' }
      start_on    { '13:00' }
      end_on      { '14:00' }
    end

    factory :activity3 do
      start_on  { '12:30' }
      end_on    { '13:30' }
      pool_zone { 'C' }
    end

    factory :activity4 do
      day_of_week { 'Środa' }
      start_on    { '12:40' }
      end_on      { '13:40' }
    end
  end
end
