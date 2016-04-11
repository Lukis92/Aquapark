# == Schema Information
#
# Table name: entry_types
#
#  id           :integer          not null, primary key
#  kind         :string           not null
#  kind_details :string           not null
#  description  :text
#  price        :decimal(5, 2)    not null
#

class EntryType < ActiveRecord::Base
#**VALIDATIONS*******************************************************#
validates :kind, presence: true
validates :kind_details, presence: true, length: {minimum: 5, maximum: 20}
validates :description, length: {minimum: 5, maximum: 100}, allow_blank: true
validates :price, presence: true
#########################################################################

#**ASSOCIATIONS**********#
has_many :bought_details
#************************#
KIND = ['Bilet', 'Karnet']

end
