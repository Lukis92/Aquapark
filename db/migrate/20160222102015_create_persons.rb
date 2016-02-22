class CreatePersons < ActiveRecord::Migration
  def change
    create_table :persons do |t|
      t.column :pesel, :string, null: false
      t.column :first_name, :string, null: false
      t.column :last_name, :string, null: false
      t.column :email, :string, null: false
      t.column :data_of_birth, :date, null: false
      t.column :password_digest, :string, null: false
      t.timestamps null: false
    end
  end
end
