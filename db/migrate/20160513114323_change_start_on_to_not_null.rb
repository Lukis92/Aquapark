class ChangeStartOnToNotNull < ActiveRecord::Migration
  def change
    change_column :individual_trainings, :start_on, :time, null: false
  end
end
