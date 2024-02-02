class AddBodyToPushNotification < ActiveRecord::Migration
  def up
    add_column :push_notifications, :body, :string, null: false, default: ""
  end

  def down
    remove_column :push_notifications, :body
  end
end
