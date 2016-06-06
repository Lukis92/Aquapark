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
#  accepted  :boolean          default(FALSE)
#

class Vacation < ActiveRecord::Base
  include ActiveModel::Dirty
  # **ASSOCIATIONS**********#
  belongs_to :person
  # ************************#
  # **VALIDATIONS***************************#
  validates_presence_of :start_at, :end_at, :person_id
  validate :validate_start_at, on: :create
  validate :start_at_must_be_before_end_at
  validate :timeline
  # ****************************************#

  include PgSearch
  pg_search_scope :search, against: [:start_at, :end_at, :reason],
                           associated_against: {
                             person: [:first_name, :last_name]
                           },
                           using: {
                             tsearch: { prefix: true }
                           }

  private

  def timeline
    if self.start_at_changed? || self.end_at_changed? || self.person_id_changed?
      if (person.vacations.where('start_at <= ?', start_at).count > 0 &&
         person.vacations.where('end_at >= ?', end_at).count > 0) ||
         (person.vacations.where('start_at <= ?', start_at).count > 0 &&
          person.vacations.where('end_at <= ?', end_at).count > 0 &&
          person.vacations.where('end_at >= ?', start_at).count > 0) ||
         (person.vacations.where('start_at >= ?', start_at).count > 0 &&
         person.vacations.where('start_at <= ?', end_at).count > 0 &&
         person.vacations.where('end_at >= ?', end_at).count > 0)
        errors.add(:start_at, 'Masz już urlop w tym okresie.')
      end
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
