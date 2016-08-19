class ChangeCostInTrainingCost < ActiveRecord::Migration
  def change
    change_column :training_costs, :cost, :decimal, precision: 5, scale: 2, null: false
  end
end
