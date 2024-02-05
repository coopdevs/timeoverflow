class RemoveFeaturesFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :parent_id
    remove_column :categories, :organization_id
    remove_column :categories, :name_translations
    remove_column :categories, :fqn_translations
    remove_column :categories, :children_count
    add_column :categories, :name, :string

    drop_table :categories_users
    drop_table :category_hierarchies
  end
end

