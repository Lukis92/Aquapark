class CreateEmployee < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.integer :salary, null: false
      t.date :date_of_employment, null: false
      t.boolean :is_manager, default: false

      add_foreign_key :employees, :persons
    end
  end
end
