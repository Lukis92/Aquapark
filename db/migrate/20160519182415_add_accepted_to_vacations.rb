class AddAcceptedToVacations < ActiveRecord::Migration[4.2]
  def change
    add_column :vacations, :accepted, :boolean, default: false
  end
end
