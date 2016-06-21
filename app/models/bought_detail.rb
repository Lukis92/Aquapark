# == Schema Information
#
# Table name: bought_details
#
#  id            :integer          not null, primary key
#  bought_data   :datetime         not null
#  start_on      :date
#  end_on        :date             not null
#  entry_type_id :integer          not null
#  person_id     :integer          not null
#  cost          :decimal(5, 2)    not null
#

class BoughtDetail < ActiveRecord::Base
  # **ASSOCIATIONS**********#
  belongs_to :entry_type
  belongs_to :person
  # ************************#
  # **VALIDATIONS***************************#
  before_validation :set_bought_data, :set_start_on, :set_end_on
  validates :bought_data, presence: true
  validates :cost, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }
  validate :validate_start_on
  attr_accessor :credit_card, :card_code, :days

  validates_presence_of :days
  validate :timeline
  # ****************************************#

  def active?
    (Date.today - start_on).to_i >= 0 && (Date.today - end_on).to_i <= 0
  end

  private

  def timeline
    et_bought_details = person.bought_details.includes(:entry_type).where('entry_types.kind = ?', entry_type.kind).references(:entry_type)
    if et_bought_details.exists?
      overlapping_bought_details = person.bought_details.where('((start_on <= :start_on AND end_on >= :end_on) OR
                                   (start_on <= :start_on AND end_on <= :end_on AND end_on >= :start_on) OR
                                   (start_on >= :start_on AND start_on <= :end_on AND end_on >= :end_on))',
                                  start_on: start_on, end_on: end_on)
      if overlapping_bought_details.exists?
        errors.add(:base, 'Masz już aktywną wejściówkę w tym okresie.')
      end
    end
  end

  def set_bought_data
    self.bought_data = Time.now
  end

  def set_start_on
    self.start_on = bought_data if start_on.nil?
  end

  def set_end_on
    self.days = '7' if days.nil?
    self.end_on = start_on + days.to_i
  end

  def remaining_days
    expired? ? 0 : (Date.today - end_on).to_i
  end

  def validate_start_on
    if start_on < Date.today && entry_type == 'Karnet'
      errors.add(:error,
                 "Czas rozpoczęcia jest wcześniejszy niż dzisiejsza data.")
    end
  end
end

# if (person.bought_details.where('entry_type_id = ?', entry_type.id).count > 0) &&
#    ((person.bought_details.where('start_on <= ?', start_on).count > 0 &&
#       person.bought_details.where('end_on >= ?', end_on).count > 0) ||
#    (person.bought_details.where('start_on <= ?', start_on).count > 0 &&
#     person.bought_details.where('end_on <= ?', end_on).count > 0 &&
#     person.bought_details.where('end_on >= ?', start_on).count > 0) ||
#    (person.bought_details.where('start_on >= ?', start_on).count > 0 &&
#    person.bought_details.where('start_on <= ?', end_on).count > 0 &&
#    person.bought_details.where('end_on >= ?', end_on).count > 0))
#   errors.add(:error, 'Masz już aktywną wejściówkę w tym okresie.')
# end
