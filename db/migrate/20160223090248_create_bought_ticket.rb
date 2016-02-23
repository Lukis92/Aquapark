class CreateBoughtTicket < ActiveRecord::Migration
  def change
    create_table :bought_tickets do |t|
      t.date :bought_data, null: false
      t.date :discount

      add_foreign_key :bought_tickets, :tickets
      add_foreign_key :bought_tickets, :clients
    end
  end
end
