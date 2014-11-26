class AddThemeToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :theme, :string
  end
end
