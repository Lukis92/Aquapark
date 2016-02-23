class CreateActivity < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.boolean :suggested
      t.integer :max_persons
    end
  end
end
