class AddTrainingCostsIdToIndividualTrainings < ActiveRecord::Migration
  def change
    add_reference :individual_trainings, :training_cost, index: true
    add_foreign_key :individual_trainings, :training_costs
  end
end
