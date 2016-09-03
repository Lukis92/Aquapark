# == Schema Information
#
# Table name: individual_trainings
#
#  id               :integer          not null, primary key
#  date_of_training :date             not null
#  client_id        :integer
#  trainer_id       :integer
#  start_on         :time             not null
#  end_on           :time             not null
#  training_cost_id :integer
#
require 'date'
FactoryGirl.define do
  factory :individual_training do
    date_of_training { Date.today.next_week.advance(days: 1) }
    association :client, factory: :client
    association :trainer, factory: :trainer
    start_on '12:30'
    end_on '13:30'
    association :training_cost, factory: :tc2

    factory :ind do
      association :client, factory: :client1
      association :trainer, factory: :trainer1
      start_on '11:00'
      end_on '12:00'
    end

    factory :ind2 do
      start_on '10:30'
      end_on '11:30'
    end
  end
end
