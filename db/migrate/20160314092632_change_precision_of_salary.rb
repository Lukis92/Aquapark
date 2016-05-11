class ChangePrecisionOfSalary < ActiveRecord::Migration
  def change
    change_column :people, :salary, :decimal, precision: 6, scale: 2
  end
end
