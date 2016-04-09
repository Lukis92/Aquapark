class AddEntryTypeIdToBoughtDetails < ActiveRecord::Migration
  def change
    add_reference :bought_details, :entry_type, index: true
    add_foreign_key :bought_details, :entry_types
  end
end
