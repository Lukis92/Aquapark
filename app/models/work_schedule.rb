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
#**VALIDATIONS***************************#
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :start_must_be_before_end_time
#****************************************#

#**ASSOCIATIONS**********#
belongs_to :person
#***********************#

DAYS = ['Poniedziałek', 'Wtorek', 'Środa', 'Czwartek', 'Piątek', 'Sobota', 'Niedziela']
#**METHODS***************************************************#
private
  def start_must_be_before_end_time
    errors.add(:start_time, "must be before end time") unless
      start_time < end_time
  end

end
