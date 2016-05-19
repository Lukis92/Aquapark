# == Schema Information
#
# Table name: work_schedules
#
#  id          :integer          not null, primary key
#  start_time  :time             not null
#  end_time    :time             not null
#  day_of_week :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#

class WorkSchedule < ActiveRecord::Base
  # **ASSOCIATIONS**********#
  belongs_to :person
  # ************************#

  # **VALIDATIONS***************************#
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates_uniqueness_of :day_of_week, scope: :person_id
  validates :day_of_week, presence: true
  validate :start_must_be_before_end_time
  validate :person_existing

  # ****************************************#

  DAYS = %w(Poniedziałek Wtorek Środa Czwartek Piątek Sobota Niedziela).freeze
  # **METHODS***************************************************#
  def start_must_be_before_end_time
    errors.add(:start_time, 'musi być przed godziną zakończenia pracy') unless
      start_time < end_time
  end

  def person_existing
    errors.add(:person_id, :missing) if person.blank?
  end

  def next_n_days(amount, day_of_week)
    (Date.today...Date.today+7*amount).select do |d|
      d.wday == day_of_week
    end
  end
  # ************************************************************#
end
