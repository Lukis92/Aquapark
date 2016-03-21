class CreateWorkSchedules < ActiveRecord::Migration
  def change
    create_table :work_schedules do |t|
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.string :day_of_week, null: false
      t.timestamps null: false
    end
  end
end
