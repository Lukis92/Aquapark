class AddPersonIdToNews < ActiveRecord::Migration
  def change
    add_column :news, :person_id, :integer
    add_index :news, :person_id
  end
end
