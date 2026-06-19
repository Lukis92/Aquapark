class AddPersonIdToBoughtDetails < ActiveRecord::Migration[4.2]
  def change
    add_reference :bought_details, :person, index: true
    add_foreign_key :bought_details, :people
  end
end
