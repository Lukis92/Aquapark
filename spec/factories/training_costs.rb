# == Schema Information
#
# Table name: training_costs
#
#  id       :integer          not null, primary key
#  duration :integer          not null
#  cost     :decimal(5, 2)    not null
#

FactoryGirl.define do
  factory :training_cost do
    duration 140
    cost 120

    factory :tc2 do
      duration 60
      cost 100
    end
  end
end
