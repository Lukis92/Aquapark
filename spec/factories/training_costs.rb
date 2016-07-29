# == Schema Information
#
# Table name: training_costs
#
#  id       :integer          not null, primary key
#  duration :integer          not null
#  cost     :decimal(5, 2)
#

FactoryGirl.define do
  factory :training_cost do
    duration 140
    cost 120.00
  end
end
