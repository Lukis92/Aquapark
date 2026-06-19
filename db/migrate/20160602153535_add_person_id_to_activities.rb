class AddPersonIdToActivities < ActiveRecord::Migration[4.2]
  def change
    add_reference :activities, :person, index: true
    add_foreign_key :activities, :people
  end
end
