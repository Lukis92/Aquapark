class AddCostToBoughtDetails < ActiveRecord::Migration[4.2]
  def change
    add_column :bought_details, :cost, :decimal, precision: 5, scale: 2, null: false
  end
end
