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
  validates :kind, presence: true
  validates :kind_details, presence: true
  validates :description, presence: true, allow_blank: true
  validates :price, presence: true
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
