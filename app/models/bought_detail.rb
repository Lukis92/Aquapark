# == Schema Information
#
# Table name: bought_details
#
#  id            :integer          not null, primary key
#  bought_data   :datetime         not null
#  end_on        :date             not null
#  entry_type_id :integer
#  person_id     :integer
#  start_on      :date
#  cost          :decimal(5, 2)    not null
#

class BoughtDetail < ActiveRecord::Base
  belongs_to :entry_type
  belongs_to :person
  before_validation :set_bought_data, :set_start_on, :set_end_on
  validates :bought_data, presence: true
  validates :cost, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }
  validate :validate_start_on
  attr_accessor :credit_card, :card_code, :days

  validate :timeline

  def expired?
    (Date.today - end_on).to_i <= 0
  end

  private

  def timeline
    if person.bought_details.where('start_on > ?', start_on).count > 0 &&
       person.bought_details.where('end_on < ?', end_on).count > 0
      errors.add(:start_on, 'Masz już aktywny karnet w tym okresie.')
    end
  end

  def set_bought_data
    self.bought_data = Date.today
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
    if start_on < Date.today
      errors.add(:bought_details, "Czas rozpoczęcia nie może być wcześniejszy niż dzisiejsza data.")
    end
  end
end
# 2016-04-28 - 2016-05-05
# 2016-05-29 - 2016-06-05
