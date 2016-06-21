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
  validate :set_end_on, if: :should_validate_end_on?
  validates_presence_of :start_on, :date_of_training, :training_cost_id
  validates_presence_of :end_on, if: :set_end_on
  validate :date_of_training_validation, if: :should_validate_date_of_training?
  validate :client_individual_training_validation
  validate :trainer_individual_training_validation
  # ****************************************#
  attr_accessor :credit_card, :card_code
  include PgSearch
  pg_search_scope :search, against: [:date_of_training, :end_on, :start_on],
                           associated_against:
                           { trainer: [:first_name, :last_name],
                             client: [:first_name, :last_name],
                             training_cost: [:duration, :cost] },
                           using: {
                             tsearch: { prefix: true }
                           }

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

  def should_validate_date_of_training?
    !date_of_training.nil? && !end_on.nil?
  end

  def should_validate_individual_training?
    !date_of_training.nil? && !end_on.nil? && date_of_training_validation
  end

  def should_validate_end_on?
    !start_on.nil? && !training_cost_id.nil?
  end

  def date_of_training_validation
    if date_of_training < Date.today
      errors.add(:error, 'Nie możesz ustalać terminu treningu wcześniej niż dzień dzisiejszy.')
    end
    trainer.work_schedules.each do |ti|
      if ti.day_of_week == translate_date(date_of_training)
        unless start_on >= ti.start_time && start_on <= ti.end_time &&
               end_on >= ti.start_time && end_on <= ti.end_time
          errors.add(:error, 'Trening jest poza grafikiem pracy trenera.')
        end
      end
    end
  end

  def client_individual_training_validation
    client.individual_trainings_as_client.where('date_of_training = ?', date_of_training).each do |ci|
      if (start_on...end_on).overlaps?(ci.start_on...ci.end_on)
        errors.add(:error, 'Masz w tym czasie inny trening.')
      end
    end
  end

  def trainer_individual_training_validation
    trainer.individual_trainings_as_trainer.each do |ti|
      if date_of_training == ti.date_of_training
        if (start_on...end_on).overlaps?(ti.start_on...ti.end_on)
          errors.add(:error, 'Trener ma w tym czasie inny trening.')
        end
      end
    end
  end

  
  def set_end_on
    unless training_cost_id.blank?
      training = TrainingCost.where(id: training_cost_id).first
      self.end_on = start_on + training.duration.minutes
    end
  end

  def self.text_search(query, querydate)
    if query.present? && querydate.blank?
      search(query)
    elsif query.present? && querydate.present?
      search(query+' '+querydate)
    elsif query.blank? && querydate.present?
      search(querydate)
    else
      all
    end
  end
end
