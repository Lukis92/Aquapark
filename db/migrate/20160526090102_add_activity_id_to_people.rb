class AddActivityIdToPeople < ActiveRecord::Migration
  def change
    add_reference :people, :activity, index: true
    add_foreign_key :people, :activities
  end
end
