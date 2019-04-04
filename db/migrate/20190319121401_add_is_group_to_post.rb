class AddIsGroupToPost < ActiveRecord::Migration
  def change
    add_column :posts, :is_group, :boolean, default: false
  end
end
