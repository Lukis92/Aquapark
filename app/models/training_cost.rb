# == Schema Information
#
# Table name: training_costs
#
#  id       :integer          not null, primary key
#  duration :integer          not null
#  cost     :decimal(5, 2)
#

class TrainingCost < ActiveRecord::Base
  DECIMAL_REGEX = /\A\d+(?:\.\d{0,2})?\z/
  has_many :individual_trainings

  validates :duration, presence: true, uniqueness: true
  validates :cost, presence: true, format: { with: DECIMAL_REGEX },
                     numericality: { greater_than: 0, less_than: 999 }
  def full_duration
    "#{duration} min. - #{cost.nice} zł"
  end
end
