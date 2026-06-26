class PriceChange < ApplicationRecord
  belongs_to :priceable, polymorphic: true

  validates :old_price, :new_price, :changed_at, presence: true

  scope :recent_first, -> { order(changed_at: :desc) }

  def difference
    new_price - old_price
  end

  def increase?
    difference > 0
  end
end
