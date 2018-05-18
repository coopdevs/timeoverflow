class ChangeOrganizationsNameConstraints < ActiveRecord::Migration
  def up
    change_column_null :organizations, :name, false
    add_index :organizations, :name, unique: true
  end

  def down
    change_column_null :organizations, :name, true
    remove_index :organizations, :name
  end
end
