module HasPriceHistory
  extend ActiveSupport::Concern

  included do
    has_many :price_changes, as: :priceable, dependent: :destroy
    before_update :record_price_change, if: :price_attribute_changed?
  end

  class_methods do
    def price_attribute
      :price
    end
  end

  private

  def price_attribute_changed?
    send(:"#{self.class.price_attribute}_changed?")
  end

  def record_price_change
    attr = self.class.price_attribute
    price_changes.build(
      old_price: send(:"#{attr}_was"),
      new_price: send(attr),
      changed_by: Thread.current[:current_person_name],
      changed_at: Time.current
    )
  end
end
