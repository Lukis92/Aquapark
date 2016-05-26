class AddPersonIdToNews < ActiveRecord::Migration
  def change
    add_reference :news, :person, index: true
    add_foreign_key :news, :people
  end
end
