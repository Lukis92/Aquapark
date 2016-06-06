# == Schema Information
#
# Table name: training_costs
#
#  id       :integer          not null, primary key
#  duration :integer          not null
#  cost     :decimal(5, 2)
#

class TrainingCost < ActiveRecord::Base
  has_many :individual_trainings

  validates_presence_of :duration, :cost
  validates_uniqueness_of :duration

  def full_duration
    "#{duration} min."
  end
end
