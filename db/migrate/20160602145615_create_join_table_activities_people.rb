class CreateJoinTableActivitiesPeople < ActiveRecord::Migration
  def change
    create_join_table :activities, :people do |t|
      t.index [:activity_id, :person_id]
      t.index [:person_id, :activity_id]
      t.date :date
    end
  end
end
