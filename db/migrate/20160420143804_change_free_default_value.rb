class ChangeFreeDefaultValue < ActiveRecord::Migration
    def change
        change_column :vacations, :free, :boolean, default: false
    end
end
