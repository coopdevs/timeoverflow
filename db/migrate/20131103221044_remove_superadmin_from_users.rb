class RemoveSuperadminFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :superadmin
  end

  def down
    add_column :users, :superadmin, :boolean
  end
end
