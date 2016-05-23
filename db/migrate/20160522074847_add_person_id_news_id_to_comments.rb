class AddPersonIdNewsIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :person_id, :integer
    add_index :comments, :person_id

    add_column :comments, :news_id, :integer
    add_index :comments, :news_id
  end
end
