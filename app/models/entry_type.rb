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
  KIND = %w(Bilet Karnet).freeze

  # **VALIDATIONS*******************************************************#
  DECIMAL_REGEX = /\A\d+(?:\.\d{0,2})?\z/
  validates :kind, presence: true
  validates :kind_details, presence: true, length: { minimum: 3 }
  validates :description, presence: false, allow_blank: true,
                          length: { minimum: 3 }
  validates :price, presence: true, format: { with: DECIMAL_REGEX },
                     numericality: { greater_than: 0, less_than: 999 }
  #########################################################################

  # **ASSOCIATIONS**********#
  has_many :bought_details
  # ************************#

  include PgSearch
  pg_search_scope :search,
                  against: [:kind, :kind_details, :description, :price],
                  using: {
                    tsearch: { prefix: true }
                  }

  def self.text_search(query)
    if query.present?
      search(query)
    else
      all
    end
  end
end
