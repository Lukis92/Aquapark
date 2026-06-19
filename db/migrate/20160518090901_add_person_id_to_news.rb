class AddPersonIdToNews < ActiveRecord::Migration[4.2]
  def change
    add_reference :news, :person, index: true
    add_foreign_key :news, :people
  end
end
