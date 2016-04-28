class ChangeDataTypeForBoughtDetail < ActiveRecord::Migration
    def change
        change_column(:bought_details, :bought_data, :datetime)
    end
end
