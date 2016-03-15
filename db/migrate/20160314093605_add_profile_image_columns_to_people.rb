class AddProfileImageColumnsToPeople < ActiveRecord::Migration
  def up
    add_attachment :people, :profile_image
  end

  def down
    remove_attachment :people, :profile_image
  end
end
