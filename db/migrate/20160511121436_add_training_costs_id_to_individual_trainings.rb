class AddTrainingCostsIdToIndividualTrainings < ActiveRecord::Migration[4.2]
  def change
    add_reference :individual_trainings, :training_cost, index: true
    add_foreign_key :individual_trainings, :training_costs
  end
end
