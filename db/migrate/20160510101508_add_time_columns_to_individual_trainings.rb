class AddTimeColumnsToIndividualTrainings < ActiveRecord::Migration
  def change
    add_column :individual_trainings, :start_on, :time, null: false
    add_column :individual_trainings, :end_on, :time, null: false
  end
end
