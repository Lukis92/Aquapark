class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :pesel, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :date_of_birth, null: false
      t.string :email, null: false
      t.string :type, null: false
      t.decimal :salary, allow_nil: true, precision: 7, scale: 2
      t.date :hiredate, null: true
    end
  end
end
