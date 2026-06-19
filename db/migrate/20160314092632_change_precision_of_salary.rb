class ChangePrecisionOfSalary < ActiveRecord::Migration[4.2]
  def change
    change_column :people, :salary, :decimal, precision: 6, scale: 2
  end
end
