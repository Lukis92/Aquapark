# == Schema Information
#
# Table name: individual_trainings
#
#  id               :integer          not null, primary key
#  date_of_training :date             not null
#  client_id        :integer
#  trainer_id       :integer
#  end_on           :time             not null
#  training_cost_id :integer
#  start_on         :time             not null
#

class IndividualTraining < ActiveRecord::Base
  # **ASSOCIATIONS**********#
  belongs_to :trainer, class_name: 'Person', foreign_key: 'trainer_id'
  belongs_to :client, class_name: 'Person', foreign_key: 'client_id'
  belongs_to :training_cost
  # ************************#
  # **VALIDATIONS***************************#
  before_validation :set_end_on
  validate :date_of_training_validation
  validates :start_on, :end_on, overlap: true
  # ****************************************#

  attr_accessor :duration, :day
  def available_day
    @days = WorkSchedule.where(id: :trainer_id)
  end

  DAYS_IN_PL = {
    'Monday' => 'Poniedziałek',
    'Tuesday' => 'Wtorek',
    'Wednesday' => 'Środa',
    'Thursday' => 'Czwartek',
    'Friday' => 'Piątek',
    'Saturday' => 'Sobota',
    'Sunday' => 'Niedziela'
  }.freeze

  private

  def translate_date(daytime)
    DAYS_IN_PL[daytime.strftime('%A')]
  end

  def date_of_training_validation
    trainer.work_schedules.any? do |ti|
      if ti.day_of_week == translate_date(date_of_training)
        unless ti.start_time <= start_on && ti.end_time <= end_on
          errors.add(:start_on, 'Trening jest poza grafikiem pracy trenera.')
        end
      else
        errors.add(:day_of_week, 'Trening jest poza grafikiem pracy trenera.')
      end
    end

  def overlap?(x,y)
    (x.start_on - y.end_on) * (y.start_on - x.end_on) >= 0
  end

    # if trainer.individual_trainings_as_trainer.any? do |ti|
    #   ti.date_of_training == date_of_training
    # else
    #   errors.add(:date_of_training,
    #   "Trening jest poza grafikiem pracy trenera.")
    # end
    # if trainer.individual_trainings_as_trainer
    #           .where(translate_date('date_of_training') == date_of).count > 0
    #   trainer.individual_trainings_as_trainer.each_with_index do |ti, index|
    #     if translate_date(ti.date_of_training) == date_of_training
    #     elsif (translate_date(ti.date_of_training) != date_of_training &&
    #       index == trainers.individual_trainings_as_trainer.size - 1)
    # if trainer.individual_trainings_as_trainer
    #           .where('start_on > ?', start_on).count > 0 ||
    #    trainer.individual_trainings_as_trainer
    #           .where('end_on < ?', start_on).count > 0
  end

  def set_end_on
    training = TrainingCost.where(id: training_cost_id).first
    self.end_on = start_on + training.duration.minutes
  end
end
