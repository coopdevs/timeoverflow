class AddTagsToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :tags, :text, array: true, default: []
  end
end
