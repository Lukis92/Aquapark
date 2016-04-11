# == Schema Information
#
# Table name: bought_details
#
#  id            :integer          not null, primary key
#  bought_data   :date             not null
#  end_on        :date             not null
#  entry_type_id :integer
#  person_id     :integer
#  start_on      :date
#

class BoughtDetail < ActiveRecord::Base
    belongs_to :entry_type
    belongs_to :person
    before_save :set_bought_data, :set_end_on

    attr_accessor :credit_card, :card_code, :days

    def set_bought_data
        self.bought_data = Date.today
    end

    def set_end_on
        days = "7" if days.nil?
        self.end_on = Date.today + days.to_i
    end
end
