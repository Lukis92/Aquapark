class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.integer  :person_id,       null: false
      t.integer  :actor_id
      t.string   :notifiable_type
      t.integer  :notifiable_id
      t.string   :kind,            null: false
      t.text     :message,         null: false
      t.datetime :read_at

      t.timestamps
    end

    add_index :notifications, :person_id
    add_index :notifications, [:notifiable_type, :notifiable_id]
    add_index :notifications, :read_at
    add_foreign_key :notifications, :people, column: :person_id
    add_foreign_key :notifications, :people, column: :actor_id
  end
end
