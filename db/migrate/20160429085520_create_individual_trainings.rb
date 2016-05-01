class CreateIndividualTrainings < ActiveRecord::Migration
  def change
    create_table :individual_trainings do |t|
      t.decimal :cost, precision: 7, scale: 2, null: false
      t.datetime :date_of_training, null: false
    end
  end
end
