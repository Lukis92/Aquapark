class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      add_foreign_key :persons
      t.timestamps null: false
    end
  end
end
