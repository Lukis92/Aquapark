class CreateBoughtPasses < ActiveRecord::Migration
  def change
    create_table :bought_passes do |t|
      t.date :bought_data, null: false
      t.date :start_data, null: false
      t.date :end_data, null: false
      add_foreign_key :bought_passes, :clients
      add_foreign_key :bought_passes, :passes
    end
  end
end
