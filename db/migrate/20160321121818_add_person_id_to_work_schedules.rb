class AddPersonIdToWorkSchedules < ActiveRecord::Migration
  def change
    add_column :work_schedules, :person_id, :integer
    add_index :work_schedules, :person_id
  end
end
