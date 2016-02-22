class DropPeopleTable < ActiveRecord::Migration
  def up
    drop_table :people
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
