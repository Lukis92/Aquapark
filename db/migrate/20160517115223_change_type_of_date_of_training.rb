class ChangeTypeOfDateOfTraining < ActiveRecord::Migration
  def change
    change_column :individual_trainings, :date_of_training, :date
  end
end
