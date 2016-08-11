# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  name        :string(20)       not null
#  description :text
#  active      :boolean          not null
#  day_of_week :string(20)       not null
#  start_on    :time             not null
#  end_on      :time             not null
#  pool_zone   :string(1)        not null
#  max_people  :integer
#  person_id   :integer          not null
#
require 'faker'
ZONE = %w(A B C D E F).freeze
DNI_TYGODNIA = %w(Poniedziałek Wtorek Środa Czwartek Piatek Sobota Niedziela).freeze
FactoryGirl.define do
  factory :activity do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence(3, true, 4) }
    active { Faker::Boolean.boolean }
    day_of_week { DNI_TYGODNIA.to_a.sample }
    start_on { Faker::Time.between(1.days.ago, Date.today, :morning).strftime('%H:%M') }
    end_on { Faker::Time.between(1.days.ago, Date.today, :afternoon).strftime('%H:%M') }
    pool_zone { ZONE.sample }
    max_people { Faker::Number.number(2) }
    association :person, factory: :trainer
  end
end
