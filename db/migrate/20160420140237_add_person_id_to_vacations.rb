class AddPersonIdToVacations < ActiveRecord::Migration[4.2]
  def change
    add_reference :vacations, :person, index: true
    add_foreign_key :vacations, :people
  end
end
