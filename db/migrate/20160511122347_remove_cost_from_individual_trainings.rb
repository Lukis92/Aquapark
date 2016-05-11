class RemoveCostFromIndividualTrainings < ActiveRecord::Migration
  def change
    remove_column :individual_trainings, :cost
  end
end
