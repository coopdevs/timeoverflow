class RemoveDeprecatedAttributesFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :permanent
    remove_column :posts, :joinable
    remove_column :posts, :global
  end
end
