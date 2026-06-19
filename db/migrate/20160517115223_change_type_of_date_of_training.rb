class ChangeTypeOfDateOfTraining < ActiveRecord::Migration[4.2]
  def change
    change_column :individual_trainings, :date_of_training, :date
  end
end
