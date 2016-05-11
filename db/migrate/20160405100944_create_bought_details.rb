class CreateBoughtDetails < ActiveRecord::Migration
  def change
    create_table :bought_details do |t|
      t.date :bought_data, null: false
      t.date :start_on, null: true
      t.date :end_on, null: false
    end
  end
end
