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

FactoryGirl.define do
  factory :individual_training do
    date_of_training '2016-08-23'# next tuesday
    association :client, factory: :client
    association :trainer, factory: :trainer
    start_on '12:30'
    end_on '13:30'
    association :training_cost, factory: :tc2

    factory :ind2 do
      start_on '10:30'
      end_on '11:30'
    end
  end

  factory :ind, parent: :individual_training, class: 'IndividualTraining' do
    date_of_training '2016-08-23'
    association :client, factory: :client
    association :trainer, factory: :trainer
    start_on '11:00'
    end_on '12:00'
    association :training_cost, factory: :tc2
  end
end
