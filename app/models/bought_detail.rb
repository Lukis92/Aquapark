# == Schema Information
#
# Table name: bought_details
#
#  id                 :integer          not null, primary key
#  bought_data        :date             not null
#  start_on           :date
#  end_on             :date             not null
#  entry_type_id      :integer
#  person_id          :integer
#  credit_card_number :string           not null
#

class BoughtDetail < ActiveRecord::Base
  belongs_to :entry_type
  belongs_to :person
  before_save :set_bought_data, :set_end_on

  attr_accessor :card_code

  def set_bought_data
    self.bought_data = Date.today
  end

  def set_end_on
    self.end_on = Date.today + 1
  end
end
