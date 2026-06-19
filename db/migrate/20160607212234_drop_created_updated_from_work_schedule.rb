class DropCreatedUpdatedFromWorkSchedule < ActiveRecord::Migration[4.2]
  def change
    remove_column :work_schedules, :created_at, :updated_at
  end
end
