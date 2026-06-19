class CreateVacations < ActiveRecord::Migration[4.2]
  def change
    create_table :vacations do |t|
      t.date :start_at, null: false
      t.date :end_at, null: false
      t.boolean :free, null: false
      t.text :reason, null: true
    end
  end
end
