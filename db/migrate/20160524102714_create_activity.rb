class CreateActivity < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name, limit: 20, null: false
      t.text :description
      t.boolean :active, null: false
      t.string :day_of_week, limit: 20, null: false
      t.time :start_on, null: false
      t.time :end_on, null: false
      t.column :pool_zone, 'char(1)', null: false
      t.integer :max_people
    end
  end
end
