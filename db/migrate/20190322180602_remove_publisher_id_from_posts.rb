class RemovePublisherIdFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :publisher_id
  end
end
