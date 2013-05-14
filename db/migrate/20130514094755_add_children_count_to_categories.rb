class AddChildrenCountToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :children_count, :integer
  end
end
