class AddPersonIdNewsIdToLikes < ActiveRecord::Migration[4.2]
  def change
    add_reference :likes, :person, index: true
    add_foreign_key :likes, :people

    add_reference :likes, :news, index: true
    add_foreign_key :likes, :news
  end
end
