class AllowNullPeselForClients < ActiveRecord::Migration[8.1]
  def up
    change_column_null :people, :pesel, true
    change_column_default :people, :pesel, nil
  end

  def down
    Person.where(type: 'Client', pesel: nil).update_all(pesel: '00000000000')
    change_column_null :people, :pesel, false
  end
end
