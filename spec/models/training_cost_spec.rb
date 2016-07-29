# == Schema Information
#
# Table name: training_costs
#
#  id       :integer          not null, primary key
#  duration :integer          not null
#  cost     :decimal(5, 2)
#

require 'rails_helper'

RSpec.describe TrainingCost, :type => :model do
  it 'has a valid factory' do
    expect(build(:training_cost)).to be_valid
  end

  it 'is invalid without a duration' do
    expect(build(:training_cost, duration: nil)).to_not be_valid
  end
end
