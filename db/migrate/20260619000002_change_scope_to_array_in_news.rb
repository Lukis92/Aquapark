class ChangeScopeToArrayInNews < ActiveRecord::Migration[8.1]
  def up
    execute "ALTER TABLE news ALTER COLUMN scope TYPE varchar[] USING ARRAY[scope]::varchar[]"
    change_column_default :news, :scope, []
  end

  def down
    change_column_default :news, :scope, nil
    execute "ALTER TABLE news ALTER COLUMN scope TYPE varchar USING array_to_string(scope, ',')"
    change_column_null :news, :scope, false
  end
end
