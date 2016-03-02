class DropPeople < ActiveRecord::Migration
  def change
    drop_table :people, force: :cascade
  end
end
