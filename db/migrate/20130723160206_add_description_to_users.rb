class AddDescriptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :description, :text
  end
end
