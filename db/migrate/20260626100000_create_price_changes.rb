class CreatePriceChanges < ActiveRecord::Migration[5.0]
  def change
    create_table :price_changes do |t|
      t.references :priceable, polymorphic: true, null: false, index: true
      t.decimal :old_price, precision: 8, scale: 2, null: false
      t.decimal :new_price, precision: 8, scale: 2, null: false
      t.string :changed_by
      t.datetime :changed_at, null: false
    end
  end
end
