# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  name        :string(20)       not null
#  description :text
#  active      :boolean          not null
#  day_of_week :string(20)       not null
#  start_on    :time             not null
#  end_on      :time             not null
#  pool_zone   :string(1)        not null
#  max_people  :integer
#  person_id   :integer          not null
#

class Activity < ActiveRecord::Base
  # **ASSOCIATIONS*************************************************************#
  has_many :activities_people
  has_many :people, through: :activities_people
  belongs_to :person
  ##############################################################################

  # **VALIDATIONS**************************************************************#
  validates_presence_of :name, :start_on, :end_on, :day_of_week, :pool_zone,
                        :person_id
  validate :start_on_must_be_before_end_on
  validate :not_overlapping_activity
  validate :not_overlapping_trainer_work
  ##############################################################################

  # **PG_SEARCH***************************************************************#
  include PgSearch
  pg_search_scope :search, against: [:name, :description, :active, :day_of_week,
                                     :start_on, :end_on, :pool_zone,
                                     :max_people],
                           using: { tsearch: { prefix: true } }
  # ***************************************************************************#

  # **METHODS******************************************************************#
  DAYS = %w(Poniedziałek Wtorek Środa Czwartek Piątek Sobota Niedziela).freeze
  # Getting next n dates of day_of_week
  def next_n_days(n)
    day = I18n.t(:"activerecord.attributes.activity.day_number.#{day_of_week}",
                 day_of_week)
    (Date.today...Date.today + 7 * n).select do |d|
      d.wday == day
    end
  end

  # PostgreSQL search
  def self.text_search(query)
    if query.present?
      search(query)
    else
      all
    end
  end

  private

  # check if new activity not overlap with another
  def not_overlapping_activity
    overlapping_activity = Activity.where(day_of_week: day_of_week)
                                   .where(pool_zone: pool_zone)

    activities = Activity.where(id: id)
    if activities.blank?
      overlapping_activity.each do |oa|
        if (start_on...end_on).overlaps?(oa.start_on...oa.end_on)
          errors.add(:base, "W tym czasie i strefie odbywają się już \
                             inne zajęcia.")
        end
      end
    else
      overlapping_activity.where('id != :id', id: id).each do |oa|
        if (start_on...end_on).overlaps?(oa.start_on...oa.end_on)
          errors.add(:base, "W tym czasie i strefie odbywają się już \
                             inne zajęcia.")
        end
      end
    end
  end

  # check if new activity not overlap with trainer work(activity || training)
  def not_overlapping_trainer_work
    overlapping_trainer_activities = Activity.where(person_id: person_id)
                                             .where(day_of_week: day_of_week)
    overlapping_trainer_it = IndividualTraining.where(trainer_id: person_id)

    overlapping_works = overlapping_trainer_activities + overlapping_trainer_it

    trainers = Activity.where(person_id: person_id)
    if trainers.blank?
      overlapping_works.each do |ot|
        if ot[:day_of_week].present?
          if ot.date_of_training.strftime('%A') == BackendController.helpers
             .translate_day_eng(day_of_week)
            if (start_on...end_on).overlaps?(ot.start_on...ot.end_on)
              errors.add(:base, 'W tym czasie trener ma inne zajęcia.')
            end
          end
        elsif ot[:date_of_training].present?
          if (start_on...end_on).overlaps?(ot.start_on...ot.end_on)
            errors.add(:base, 'W tym czasie trener ma inne zajęcia.')
          end
        end
      end
    else
      overlapping_works.each do |ot|
        next unless ot.id != id
        if ot[:day_of_week].present?
          if ot.date_of_training.strftime('%A') == BackendController.helpers
             .translate_day_eng(day_of_week)
            if (start_on...end_on).overlaps?(ot.start_on...ot.end_on)
              errors.add(:base, 'W tym czasie trener ma inne zajęcia.')
            end
          end
        elsif ot[:date_of_training].present?
          if (start_on...end_on).overlaps?(ot.start_on...ot.end_on)
            errors.add(:base, 'W tym czasie trener ma inne zajęcia.')
          end
        end
      end
    end
  end

  # Validation start_on and end_on
  def start_on_must_be_before_end_on
    if start_on.present? && end_on.present?
      if end_on <= start_on
        errors.add(:base, 'Godzina rozpoczęcia musi być wcześniejsza \
                           niż zakończenia')
      end

      if start_on + 30.minutes > end_on
        errors.add(:base, 'Zajęcia muszą trwać min. 30 minut.')
      end
    end
  end

  # ***************************************************************************#
end
