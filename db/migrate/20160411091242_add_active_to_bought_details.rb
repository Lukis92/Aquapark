class AddActiveToBoughtDetails < ActiveRecord::Migration
  def change
    add_column :bought_details, :active, :boolean, :default => true
  end
end
