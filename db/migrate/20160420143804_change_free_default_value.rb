class ChangeFreeDefaultValue < ActiveRecord::Migration[4.2]
  def change
    change_column :vacations, :free, :boolean, default: false
  end
end
