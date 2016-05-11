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
  pending "add some examples to (or delete) #{__FILE__}"
end
