class CreateNews < ActiveRecord::Migration[4.2]
  def change
    create_table :news do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.string :scope, null: false
      t.timestamps null: false
    end
  end
end
