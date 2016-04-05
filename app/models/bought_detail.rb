class BoughtDetail < ActiveRecord::Base
  belongs_to :entry_type
  belongs_to :person

  attr_accessor :card_number, :card_code
end
