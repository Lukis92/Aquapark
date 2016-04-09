class AddPersonIdToBoughtDetails < ActiveRecord::Migration
  def change
    add_reference :bought_details, :person, index: true
    add_foreign_key :bought_details, :people
  end
end
