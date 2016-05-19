class AddPersonIdNewsIdToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :person_id, :integer
    add_index :likes, :person_id

    add_column :likes, :news_id, :integer
    add_index :likes, :news_id
  end
end
