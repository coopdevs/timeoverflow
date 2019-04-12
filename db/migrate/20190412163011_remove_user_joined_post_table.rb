class RemoveUserJoinedPostTable < ActiveRecord::Migration
  def change
    drop_table :user_joined_post
  end
end
