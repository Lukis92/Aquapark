# == Schema Information
#
# Table name: work_schedules
#
#  id          :integer          not null, primary key
#  start_time  :time             not null
#  end_time    :time             not null
#  day_of_week :string           not null
#  person_id   :integer          not null
#

class WorkSchedule < ActiveRecord::Base
  # **ASSOCIATIONS**********#
  belongs_to :person
  # ************************#

  # **VALIDATIONS***************************#
  validates_presence_of :start_time, :end_time, :day_of_week, :person_id
  validates :day_of_week, uniqueness: { scope: :person_id, allow_blank: false }
  validate :start_must_be_before_end_time
  validate :work_duration
  validate :person_existing
  # ****************************************#

  include PgSearch
  pg_search_scope :search, against: [:start_time, :end_time, :day_of_week],
                           associated_against: {
                             person: [:first_name, :last_name, :type]
                           },
                           using: {
                             tsearch: { prefix: true }
                           }

  DAYS = %w(Poniedziałek Wtorek Środa Czwartek Piątek Sobota Niedziela).freeze
  # **METHODS***************************************************#
  def start_must_be_before_end_time
    unless start_time.blank? || end_time.blank?
      if start_time >= end_time
        errors.add(:base, 'Czas rozpoczęcia musi być przed czasem zakończenia pracy')
      end
    end
  end

  def work_duration
    unless start_time.blank? || end_time.blank?
      if ((end_time - start_time) / 1.hour) < 1
        errors.add(:base, 'Minimalny czas pracy powinien wynosić 1 godzinę.')
      end
    end
  end

  def person_existing
    errors.add(:person_id, :missing) if person.blank?
  end

  def next_n_days(amount, day_of_week)
    day = I18n.t(:"activerecord.attributes.activity.day_number.#{day_of_week}",
                 day_of_week)
    (Date.today...Date.today + 7 * amount).select do |d|
      d.wday == day
    end
  end

  def self.text_search(query)
    t_query = I18n.t(:"activerecord.attributes.work_schedule.en_person_types.#{query}", default: '')
    if t_query.present? && query.present?
      search(t_query)
    elsif query.present?
      search(query)
    else
      all
    end
  end

  # ************************************************************#
end
