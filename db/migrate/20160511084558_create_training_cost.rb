#TrainingCost table for IndividualTraining
class CreateTrainingCost < ActiveRecord::Migration[4.2]
  def change
    create_table :training_costs do |t|
      t.integer :duration, null: false
      t.decimal :cost, precision: 5, scale: 2
    end
  end
end
