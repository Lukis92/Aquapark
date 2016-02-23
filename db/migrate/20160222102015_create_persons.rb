class CreatePersons < ActiveRecord::Migration
  def self.up
    create_table :persons do |t|
      t.string :pesel, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.date :data_of_birth, null: false
      t.string :password_digest, null: false
      # required for STI
      t.string :type
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :persons
  end
end
