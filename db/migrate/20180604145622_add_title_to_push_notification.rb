class AddTitleToPushNotification < ActiveRecord::Migration
  def up
    add_column :push_notifications, :title, :string, null: false, default: ''
  end

  def down
    remove_column :push_notifications, :title
  end
end
