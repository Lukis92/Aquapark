class CreateEntryTypes < ActiveRecord::Migration
  def change
    create_table :entry_types do |t|
      t.string :kind, null: false
      t.string :kind_details, null: false
      t.text :description
      t.decimal :price, precision: 5, scale: 2, null: false
    end
  end
end
