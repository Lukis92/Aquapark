class DropCreatedUpdatedFromWorkSchedule < ActiveRecord::Migration
  def change
    remove_column :work_schedules, :created_at, :updated_at
  end
end
