class AddOrganizationToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :organization_id, :integer
  end
end
