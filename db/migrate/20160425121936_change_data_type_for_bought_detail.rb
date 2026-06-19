class ChangeDataTypeForBoughtDetail < ActiveRecord::Migration[4.2]
  def change
    change_column(:bought_details, :bought_data, :datetime)
  end
end
