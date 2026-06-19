class AddPersonIdToWorkSchedules < ActiveRecord::Migration[4.2]
  def change
    add_reference :work_schedules, :person, index: true
    add_foreign_key :work_schedules, :people
  end
end
