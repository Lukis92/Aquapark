class AddIdToActivitiesPeople < ActiveRecord::Migration
  def change
    add_column :activities_people, :id, :primary_key
  end
end
