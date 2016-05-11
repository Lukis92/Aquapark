# == Schema Information
#
# Table name: individual_trainings
#
#  id               :integer          not null, primary key
#  cost             :decimal(7, 2)    not null
#  date_of_training :datetime         not null
#  client_id        :integer
#  trainer_id       :integer
#  start_on         :time             not null
#  end_on           :time             not null
#  training_cost_id :integer
#

class IndividualTraining < ActiveRecord::Base
  # **ASSOCIATIONS**********#
  belongs_to :trainer, class_name: 'Person', foreign_key: 'trainer_id'
  belongs_to :client, class_name: 'Person', foreign_key: 'client_id'
  belongs_to :training_cost
  # ************************#
  # **VALIDATIONS***************************#
  before_validation :set_end_on
  validate :start_on_validation
  # ****************************************#

  attr_accessor :duration, :day
  def available_day
    @days = WorkSchedule.where(id: :trainer_id)
  end

  private

  def start_on_validation
    if trainer.individual_trainings_as_trainer.where('start_on > ?', start_on).count > 0 ||
       trainer.individual_trainings_as_trainer.where('end_on <= ?', start_on).count > 0
      errors.add(:start_on, 'Czas treningu jest poza grafikiem pracy trenera.')
    end
  end

  def set_end_on
    self.end_on = start_on + duration.to_i
  end
end
