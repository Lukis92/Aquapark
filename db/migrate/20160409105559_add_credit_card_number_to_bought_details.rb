class AddCreditCardNumberToBoughtDetails < ActiveRecord::Migration
  def change
    add_column :bought_details, :credit_card_number, :string
    change_column_null :bought_details, :credit_card_number, false
  end
end
