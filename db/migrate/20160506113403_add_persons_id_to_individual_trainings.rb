class AddPersonsIdToIndividualTrainings < ActiveRecord::Migration
  def change
    add_reference :individual_trainings, :client, index: true
    add_reference :individual_trainings, :trainer, index: true

    add_foreign_key :individual_trainings, :people, column: :client_id
    add_foreign_key :individual_trainings, :people, column: :trainer_id
  end
end
