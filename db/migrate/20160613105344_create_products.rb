class CreateProducts < ActiveRecord::Migration[4.2]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 12, scale: 2

      t.timestamps null: false
    end
  end
end
