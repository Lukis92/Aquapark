class CreatePass < ActiveRecord::Migration
  def change
    create_table :passes do |t|
      t.string :type, null: false
      t.decimal :price, :scale => 2, null: false
    end
  end
end
