class AddPersonsIdToIndividualTrainings < ActiveRecord::Migration
  def change
    add_column :individual_trainings, :client_id, :integer
    add_index :individual_trainings, :client_id

    add_column :individual_trainings, :trainer_id, :integer
    add_index :individual_trainings, :trainer_id
  end
end
