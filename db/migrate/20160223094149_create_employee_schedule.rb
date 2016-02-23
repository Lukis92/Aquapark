class CreateEmployeeSchedule < ActiveRecord::Migration
  def change
    create_table :employee_schedules do |t|
      t.time :start_data, null: false
      t.time :end_data, null: false
      t.string :day_of_week, null: false

      add_foreign_key :employee_schedules, :employees 
    end
  end
end
