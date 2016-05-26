class AddPersonIdToWorkSchedules < ActiveRecord::Migration
  def change
    add_reference :work_schedules, :person, index: true
    add_foreign_key :work_schedules, :people
  end
end
