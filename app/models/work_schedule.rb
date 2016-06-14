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
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :day_of_week, uniqueness: { scope: :person_id, allow_blank: false }
  before_save :start_must_be_before_end_time
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
    unless start_time < end_time
      errors.add(:error, 'Czas rozpoczęcia musi być przed czasem zakończenia pracy')
    end
  end

  def person_existing
    errors.add(:person_id, :missing) if person.blank?
  end

  def next_n_days(amount, day_of_week)
    (Date.today...Date.today + 7 * amount).select do |d|
      d.wday == day_of_week
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
