# == Schema Information
#
# Table name: vacations
#
#  id        :integer          not null, primary key
#  start_at  :date             not null
#  end_at    :date             not null
#  free      :boolean          default(FALSE)
#  reason    :text
#  person_id :integer          not null
#  accepted  :boolean          default(FALSE)
#

class Vacation < ActiveRecord::Base
  include ActiveModel::Dirty
  # **ASSOCIATIONS**********#
  belongs_to :person
  # ************************#
  # **VALIDATIONS***************************#
  validates_presence_of :start_at, :end_at, :person_id
  validate :validate_start_at, on: :create, if: :start_at
  validate :start_at_must_be_before_end_at, if: :end_at
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
    if start_at_changed? || end_at_changed? || person_id_changed?
      overlapping_vacations = person.vacations.where('vacations.id != ?', id)
      ol_vacations = ''
      if overlapping_vacations.exists?
        ol_vacations = overlapping_vacations
                       .where('(start_at, end_at) OVERLAPS (?, ?)', start_at, end_at)
      else
        ol_vacations = person.vacations
                             .where('(start_at, end_at) OVERLAPS (?, ?)', start_at, end_at)
      end
      errors.add(:base, 'Masz już urlop w tym okresie.') if ol_vacations.exists?
    end
  end

  def validate_start_at
    if start_at < Date.today
      errors.add(:base, 'Data od nie może być wcześniejsza niż dzisiejsza data.')
    end
  end

  def start_at_must_be_before_end_at
    if end_at < start_at
      errors.add(:base, 'Data od musi być wcześniejszy niż data do.')
    end
  end

  def self.text_search(query, querydate)
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
