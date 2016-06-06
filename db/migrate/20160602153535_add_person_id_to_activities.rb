class AddPersonIdToActivities < ActiveRecord::Migration
  def change
    add_reference :activities, :person, index: true
    add_foreign_key :activities, :people
  end
end
