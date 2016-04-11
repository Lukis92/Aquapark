class RemoveStartOnFromBoughtDetails < ActiveRecord::Migration
  def change
    remove_column :bought_details, :start_on, :date
  end
end
