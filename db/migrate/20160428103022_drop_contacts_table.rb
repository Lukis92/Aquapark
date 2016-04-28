class DropContactsTable < ActiveRecord::Migration
  def change
    drop_table :contacts
  end
end
