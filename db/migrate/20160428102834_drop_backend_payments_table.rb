class DropBackendPaymentsTable < ActiveRecord::Migration
  def change
    drop_table :backend_payments
  end
end
