class ChangeActivitiesColumns < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.change :name, :string
      t.change :active, :boolean, null: true
      t.change :day_of_week, :string
      t.change :pool_zone, :string
    end
  end
end
