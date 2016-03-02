class DropClients < ActiveRecord::Migration
  def change
    drop_table :clients, force: :cascade
  end
end
