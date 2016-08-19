# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  active      :boolean
#  day_of_week :string           not null
#  start_on    :time             not null
#  end_on      :time             not null
#  pool_zone   :string           not null
#  max_people  :integer
#  person_id   :integer          not null
#

require 'faker'

FactoryGirl.define do
  factory :activity do
    name 'Fit Girls'
    description 'ss'
    active true
    day_of_week 'Wtorek'
    start_on '12:00'
    end_on '13:00'
    pool_zone 'B'
    max_people { Faker::Number.number(2) }
    association :person, factory: :trainer

    factory :first do
      name 'Swim Cycle'
      description 'Zajęcia z rowerami wodnymi.'
      active true
      day_of_week 'Wtorek'
      start_on '11:30'
      end_on '12:30'
    end

    factory :second do
      name 'Aqua Crossfit'
      description 'Wodny crossfit dla każdego'
      active true
      day_of_week 'Wtorek'
      start_on '12:40'
      end_on '13:40'
      pool_zone 'C'
      max_people '30'
    end

    # not_overlapping_activity
    # times overlap, same pool_zone
    factory :activity1 do
      start_on '11:30'
      end_on '12:30'
    end

    # same pool_zone, day_of_week, diff times
    factory :activity2 do
      day_of_week 'Wtorek'
      start_on '13:00'
      end_on '14:00'
    end

    # times overlap, diff pool_zone
    factory :activity3 do
      start_on '12:30'
      end_on '13:30'
      pool_zone 'C'
    end

    # times overlap, same pool_zone, diff day_of_week
    factory :activity4 do
      day_of_week 'Środa'
      start_on '12:40'
      end_on '13:40'
    end
  end
end
