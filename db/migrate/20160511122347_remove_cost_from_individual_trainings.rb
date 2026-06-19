class RemoveCostFromIndividualTrainings < ActiveRecord::Migration[4.2]
  def change
    remove_column :individual_trainings, :cost
  end
end
