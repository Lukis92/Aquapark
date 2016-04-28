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
  # **VALIDATIONS***************************#
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates_uniqueness_of :day_of_week, scope: :person_id
  validates :day_of_week, presence: true
  validate :start_must_be_before_end_time
  validate :person_existing
  # ****************************************#

  # **ASSOCIATIONS**********#
  belongs_to :person
  # ************************#

  DAYS = %w(Poniedziałek Wtorek Środa Czwartek Piątek Sobota Niedziela).freeze
  # **METHODS***************************************************#
  def start_must_be_before_end_time
    errors.add(:start_time, 'must be before end time') unless
      start_time < end_time
    private
  end

  def person_existing
    errors.add(:person_id, :missing) if person.blank?
  end
end
