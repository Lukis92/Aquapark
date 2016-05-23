class AddAcceptedToVacations < ActiveRecord::Migration
  def change
    add_column :vacations, :accepted, :boolean, default: false 
  end
end
