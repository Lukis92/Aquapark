class ChangeCostInTrainingCost < ActiveRecord::Migration[4.2]
  def change
    change_column :training_costs, :cost, :decimal, precision: 5, scale: 2, null: false
  end
end
