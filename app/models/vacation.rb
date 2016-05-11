# == Schema Information
#
# Table name: vacations
#
#  id        :integer          not null, primary key
#  start_at  :date             not null
#  end_at    :date             not null
#  free      :boolean          default(FALSE), not null
#  reason    :text
#  person_id :integer
#

class Vacation < ActiveRecord::Base
  # **ASSOCIATIONS**********#
  belongs_to :person
  # ************************#
  # **VALIDATIONS***************************#
  validates_presence_of :start_at, :end_at
  validate :validate_start_at, on: :create
  validate :start_at_must_be_before_end_at
  validate :timeline
  # ****************************************#

  private

  def timeline
    if (person.vacations.where('start_at <= ?', start_at).count > 0 &&
       person.vacations.where('end_at >= ?', end_at).count > 0) ||
       (person.vacations.where('start_at <= ?', start_at).count > 0 &&
        person.vacations.where('end_at <= ?', end_at).count > 0 &&
        person.vacations.where('end_at >= ?', start_at).count > 0) ||
       (person.vacations.where('start_at >= ?', start_at).count > 0 &&
       person.vacations.where('start_at <= ?', end_at).count > 0 &&
       person.vacations.where('end_at >= ?', end_at).count > 0)
      errors.add(:start_at, 'Masz już aktywny urlop w tym okresie.')
    end
  end

  def validate_start_at
    if start_at < Date.today
      errors.add(:start_at, "Czas rozpoczęcia nie może być wcześniejszy niż
      dzisiejsza data.")
    end
  end

  def start_at_must_be_before_end_at
    if end_at < start_at
      errors.add(:end_at, 'Czas rozpoczęcia musi być wcześniejszy niż czas
      zakończenia.')
    end
  end
end
