class AddIdToActivitiesPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :activities_people, :id, :primary_key
  end
end
