class ChangeStartOnToNotNull < ActiveRecord::Migration[4.2]
  def change
    change_column :individual_trainings, :start_on, :time, null: false
  end
end
