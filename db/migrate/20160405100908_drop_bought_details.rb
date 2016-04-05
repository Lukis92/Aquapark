class DropBoughtDetails < ActiveRecord::Migration
  def change
    drop_table :bought_details
  end
end
