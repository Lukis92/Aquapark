class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :pesel, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.date :data_of_birth, null: false
      t.string :password_digest, null: false
      t.timestamps null: false
    end
  end
end
