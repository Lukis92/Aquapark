# == Schema Information
#
# Table name: work_schedules
#
#  id          :integer          not null, primary key
#  start_time  :time             not null
#  end_time    :time             not null
#  day_of_week :string           not null
#  person_id   :integer          not null
#

FactoryGirl.define do
  factory :work_schedule do
    start_time '08:00'
    end_time '12:00'
    day_of_week 'Wtorek'
    association :person, factory: :trainer

    trait :wch2 do
      day_of_week 'Wtorek'
    end
  end
end
