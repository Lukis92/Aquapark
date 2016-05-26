class AddPersonIdNewsIdToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :person, index: true
    add_foreign_key :comments, :people

    add_reference :comments, :news, index: true
    add_foreign_key :comments, :news
  end
end
