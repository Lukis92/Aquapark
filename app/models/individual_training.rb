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
  validates_presence_of :start_on, :date_of_training,
                        :training_cost_id

  validates_presence_of :end_on if :set_end_on
  validate :date_and_start_on_validation
  validate :date_of_training_validation, if: :should_validate_date_of_training?
  validate :client_free_time_validation
  validate :trainer_free_time_validation
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

  private

  def should_validate_date_of_training?
   !date_of_training.nil? && !end_on.nil?
  end

  def should_validate_end_on?
    !start_on.nil? && !training_cost_id.nil?
  end

  def date_and_start_on_validation
    unless start_on.blank?
      if date_of_training < Date.today
        errors.add(:base, 'Nie możesz ustalać terminu treningu wcześniej niż dzień dzisiejszy.')
      elsif date_of_training == Date.today
        if start_on <= Time.now
          errors.add(:base, 'Godzina dzisiejszego treningu jest wcześniejsza niż obecny czas.')
        end
      end
    end
  end

  # check if trainer work while will be individual_training
  def date_of_training_validation
    unless start_on.blank?
      trainer.work_schedules.each_with_index do |ti, ind|
        if ti.day_of_week == BackendController.helpers.translate_date(date_of_training)
          if (start_on.strftime('%H:%M')..end_on.strftime('%H:%M'))
             .overlaps?(ti.start_time.strftime('%H:%M')..ti.end_time.strftime('%H:%M'))
            break
        else
            errors.add(:base, 'Trening jest poza grafikiem pracy trenera.')
            break
          end
        elsif ind == trainer.work_schedules.size - 1
          errors.add(:base, 'Trener w tym dniu nie pracuje.')
        end
      end
    end
  end

  # check if client doesn't have another training or activity
  def client_free_time_validation
    unless start_on.blank?
      client.individual_trainings_as_client.where(date_of_training: date_of_training)
            .each do |ci|
        if (start_on...end_on).overlaps?(ci.start_on...ci.end_on)
          errors.add(:base, 'Masz w tym czasie inny trening.')
        end
      end
      client.activities_people.where(date: date_of_training)
                              .where(person_id: client_id).each do |ca|
        Activity.where(id: ca.activity_id).each do |a|
          if (start_on...end_on).overlaps?(a.start_on...a.end_on)
            errors.add(:base, 'Masz w tym czasie zajęcie grupowe.')
          end
        end
      end
    end
  end

  def trainer_free_time_validation
    unless start_on.blank?
      trainer.individual_trainings_as_trainer.where(date_of_training: date_of_training)
             .each do |ti|
        if (start_on...end_on).overlaps?(ti.start_on...ti.end_on)
          errors.add(:base, 'Trener ma w tym czasie inny trening.')
        end
      end

      trainer.activities.where(person_id: trainer_id)
                        .where(day_of_week: BackendController.helpers.translate_date(date_of_training)).each do |ta|
        if (start_on...end_on).overlaps?(ta.start_on...ta.end_on)
          errors.add(:base, 'Trener ma w tym czasie inne zajęcia.')
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

  def self.text_search(query, querydate = '')
    if query.present? && querydate.blank?
      search(query)
    elsif query.present? && querydate.present?
      search(query + ' ' + querydate)
    elsif query.blank? && querydate.present?
      search(querydate)
    else
      all
    end
  end
end
