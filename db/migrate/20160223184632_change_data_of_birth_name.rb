class ChangeDataOfBirthName < ActiveRecord::Migration
  def change
    rename_column :people, :data_of_birth, :date_of_birth
  end
end
